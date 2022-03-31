// Copyright 2018 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fidl/fidl.dart' as fidl;
import 'package:fidl_fuchsia_io/fidl_async.dart';
import 'package:meta/meta.dart';
import 'package:zircon/zircon.dart';

import 'internal/_flags.dart';
import 'vnode.dart';

// ignore_for_file: public_member_api_docs, unnecessary_null_comparison, unused_import

typedef WriteFn = int Function(Uint8List);
typedef WriteFnStr = int Function(String);
typedef ReadFn = Uint8List Function();
typedef ReadFnStr = String? Function();

/// A [PseudoFile] is a file-like object whose content is generated and modified
/// dynamically on-the-fly by invoking handler functions rather than being
/// directly persisted as a sequence of bytes.
///
/// This class is designed to allow programs to publish read-only,
/// or read-write properties such as configuration options, debug flags,
/// and dumps of internal state which may change dynamically.
///
/// Although [PseudoFile] usually contain text, they can also be used for binary
/// data.
///
/// Read callback, is called when the connection to the file is opened and
/// pre-populates a buffer that will be used to when serving this file content
/// over this particular connection.
///
/// Write callback, if any, is called when the connection is closed if the file
/// content was ever modified while the connection was open.
/// Modifications are: [fidl_fuchsia_io.File#write()] calls or opening a file
/// for writing with the `OpenFlags.truncate` flag set.
class PseudoFile extends Vnode {
  final int _capacity;
  ReadFn? _readFn;
  WriteFn? _writeFn;
  bool _isClosed = false;
  final List<_FileConnection> _connections = [];

  /// Creates a new read-only [PseudoFile] backed by the specified read handler.
  ///
  /// The handler is called every time a read operation is performed on the file.  It is only allowed
  /// to read at offset 0, and all of the content returned by the handler is returned by the read
  /// operation.  Subsequent reads act the same - there is no seek position, nor ability to read
  /// content in chunks.
  PseudoFile.readOnly(this._readFn)
      : _capacity = 0,
        assert(_readFn != null);

  /// See [#readOnly()].  Wraps the callback, allowing it to return a String instead of a Uint8List,
  /// but otherwise behaves identical to [#readOnly()].
  PseudoFile.readOnlyStr(ReadFnStr fn)
      : _capacity = 0,
        assert(fn != null) {
    _readFn = _getReadFn(fn);
  }

  /// Creates new [PseudoFile] backed by the specified read and write handlers.
  ///
  /// The read handler is called every time a read operation is performed on the file.  It is only
  /// allowed to read at offset 0, and all of the content returned by the handler is returned by the
  /// read operation.  Subsequent reads act the same - there is no seek position, nor ability to read
  /// content in chunks.
  ///
  /// The write handler is called every time a write operation is performed on the file.  It is only
  /// allowed to write at offset 0, and all of the new content should be provided to a single write
  /// operation.  Subsequent writes act the same - there is no seek position, nor ability to write
  /// content in chunks.
  PseudoFile.readWrite(this._capacity, this._readFn, this._writeFn)
      : assert(_writeFn != null),
        assert(_readFn != null),
        assert(_capacity > 0);

  /// See [#readWrite()].  Wraps the read callback, allowing it to return a [String] instead of a
  /// [Uint8List].  Wraps the write callback, only allowing valid UTF-8 content to be written into
  /// the file.  Written bytes are converted into a string instance, and the passed to the handler.
  /// In every other aspect behaves just like [#readWrite()].
  PseudoFile.readWriteStr(this._capacity, ReadFnStr rfn, WriteFnStr wfn)
      : assert(_capacity > 0),
        assert(rfn != null),
        assert(wfn != null) {
    _readFn = _getReadFn(rfn);
    _writeFn = _getWriteFn(wfn);
  }

  /// Connects to this instance of [PseudoFile] and serves [fidl_fuchsia_io.File] over fidl.
  @override
  int connect(OpenFlags flags, int mode, fidl.InterfaceRequest<Node> request,
      [OpenFlags? parentFlags]) {
    if (_isClosed) {
      sendErrorEvent(flags, ZX.ERR_NOT_SUPPORTED, request);
      return ZX.ERR_NOT_SUPPORTED;
    }
    // There should be no MODE_TYPE_* flags set, except for, possibly,
    // MODE_TYPE_FILE when the target is a pseudo file.
    if ((mode & ~modeProtectionMask) & ~modeTypeFile != 0) {
      sendErrorEvent(flags, ZX.ERR_INVALID_ARGS, request);
      return ZX.ERR_INVALID_ARGS;
    }

    final connectFlags = filterForNodeReference(flags);
    final status =
        _validateFlags(parentFlags ?? Flags.fsRightsDefault(), connectFlags);
    if (status != ZX.OK) {
      sendErrorEvent(connectFlags, status, request);
      return status;
    }

    final connection = _FileConnection(
        capacity: _capacity,
        flags: connectFlags,
        file: this,
        mode: mode,
        request: fidl.InterfaceRequest<File>(request.passChannel()));

    // [connection] will also send on_open success event.
    _connections.add(connection);
    return ZX.OK;
  }

  @override
  int inodeNumber() {
    return inoUnknown;
  }

  @override
  DirentType type() {
    return DirentType.file;
  }

  NodeInfo describe() {
    return NodeInfo.withFile(FileObject(event: null));
  }

  ConnectionInfo describe2(ConnectionInfoQuery query) {
    return ConnectionInfo(representation: Representation.withFile(FileInfo()));
  }

  ReadFn _getReadFn(ReadFnStr fn) {
    return () => Uint8List.fromList(fn()!.codeUnits);
  }

  WriteFn _getWriteFn(WriteFnStr fn) {
    return (Uint8List buffer) => fn(String.fromCharCodes(buffer));
  }

  void _onClose(_FileConnection obj) {
    final result = _connections.remove(obj);
    scheduleMicrotask(() {
      obj.closeBinding();
    });
    assert(result);
  }

  int _validateFlags(OpenFlags parentFlags, OpenFlags flags) {
    if (flags & OpenFlags.directory != OpenFlags.$none) {
      return ZX.ERR_NOT_DIR;
    }
    var allowedFlags = OpenFlags.describe |
        OpenFlags.nodeReference |
        OpenFlags.posixDeprecated |
        OpenFlags.posixWritable |
        OpenFlags.posixExecutable |
        OpenFlags.cloneSameRights;
    if (_readFn != null) {
      allowedFlags |= OpenFlags.rightReadable;
    }
    if (_writeFn != null) {
      allowedFlags |= OpenFlags.rightWritable | OpenFlags.truncate;
    }

    // allowedFlags takes precedence over prohibited_flags.
    const prohibitedFlags = OpenFlags.append;

    final flagsDependentOnParentFlags = [
      OpenFlags.rightReadable,
      OpenFlags.rightWritable
    ];
    for (final flag in flagsDependentOnParentFlags) {
      if (flags & flag != OpenFlags.$none &&
          parentFlags & flag == OpenFlags.$none) {
        return ZX.ERR_ACCESS_DENIED;
      }
    }

    if (flags & prohibitedFlags != OpenFlags.$none) {
      return ZX.ERR_INVALID_ARGS;
    }
    if (flags & ~allowedFlags != OpenFlags.$none) {
      return ZX.ERR_NOT_SUPPORTED;
    }
    return ZX.OK;
  }

  @override
  void close() {
    _isClosed = true;
    // schedule a task because if user closes this as soon as
    // they open a connection, dart fidl binding throws exception due to
    // event on this fidl.
    scheduleMicrotask(() {
      for (final c in _connections) {
        c.closeBinding();
      }
      _connections.clear();
    });
  }
}

/// Implementation of fuchsia.io.File for pseudo file.
///
/// This class should not be used directly, but by [fuchsia_vfs.PseudoFile].
class _FileConnection extends File {
  final FileBinding _binding = FileBinding();

  /// open file connection flags
  final OpenFlags flags;

  /// open file mode
  final int mode;

  /// seek position in file.
  int seekPos = 0;

  /// file's maximum capacity.
  int capacity;

  /// current length of file.
  int _currentLen = 0;

  // TODO(fxbug.dev/4143): Implement a grow-able buffer.
  /// buffer which stores file content
  Uint8List _buffer = Uint8List(0);

  /// true if client wrote to this file.
  bool _wasWritten = false;

  /// Reference to PsuedoFile's Vnode.
  PseudoFile file;

  bool _isClosed = false;

  /// Constructor to init _FileConnection
  _FileConnection({
    required this.flags,
    required this.mode,
    required this.capacity,
    required this.file,
    required fidl.InterfaceRequest<File> request,
  }) : assert(file != null) {
    if (file._writeFn != null) {
      _buffer = Uint8List(capacity);
    }

    if (flags & OpenFlags.truncate != OpenFlags.$none) {
      // don't call read handler on truncate.
      _wasWritten = true;
    } else {
      final readBuf = file._readFn!();
      _currentLen = readBuf.lengthInBytes;
      if (_currentLen > capacity) {
        capacity = _currentLen;
        _buffer = Uint8List(capacity);
      }
      _buffer.setRange(0, _currentLen, readBuf);
    }
    _binding.bind(this, request);
    _binding.whenClosed.then((_) => close());
  }

  void closeBinding() {
    _binding.close();
    _isClosed = true;
  }

  @override
  Stream<File$OnOpen$Response> get onOpen {
    File$OnOpen$Response d;
    if ((flags & OpenFlags.describe) == OpenFlags.$none) {
      d = File$OnOpen$Response(ZX.ERR_NOT_FILE, null);
    } else {
      NodeInfo nodeInfo = file.describe();
      d = File$OnOpen$Response(ZX.OK, nodeInfo);
    }
    return Stream.fromIterable([d]);
  }

  // TODO(https://fxbug.dev/77623): Switch from onOpen to onConnectionInfo when
  // clients are ready.
  @override
  Stream<ConnectionInfo> get onConnectionInfo async* {}

  @override
  Future<void> advisoryLock(AdvisoryLockRequest request) async {
    throw fidl.MethodException(ZX.ERR_NOT_SUPPORTED);
  }

  @override
  Future<void> clone(
      OpenFlags flags, fidl.InterfaceRequest<Node> object) async {
    if (!Flags.inputPrecondition(flags)) {
      file.sendErrorEvent(flags, ZX.ERR_INVALID_ARGS, object);
      return;
    }
    if (Flags.shouldCloneWithSameRights(flags)) {
      if ((flags & openRights) != OpenFlags.$none) {
        file.sendErrorEvent(flags, ZX.ERR_INVALID_ARGS, object);
        return;
      }
    }

    // If SAME_RIGHTS is requested, cloned connection will inherit the same
    // rights as those from the originating connection.
    var newFlags = flags;
    if (Flags.shouldCloneWithSameRights(flags)) {
      newFlags &= (~openRights);
      newFlags |= (this.flags & openRights);
      newFlags &= ~OpenFlags.cloneSameRights;
    }

    if (!Flags.stricterOrSameRights(newFlags, this.flags)) {
      file.sendErrorEvent(flags, ZX.ERR_ACCESS_DENIED, object);
      return;
    }

    file.connect(newFlags, mode, object, this.flags);
  }

  @override
  Future<int> closeDeprecated() async {
    if (_isClosed) {
      return ZX.OK;
    }
    var status = ZX.OK;
    if (file._writeFn != null && _wasWritten) {
      status = file._writeFn!(_buffer.buffer.asUint8List(0, _currentLen));
    }
    // no more read/write operations should be possible
    scheduleMicrotask(() {
      file._onClose(this);
    });
    _isClosed = true;
    return status;
  }

  @override
  Future<void> close() async {
    final status = await closeDeprecated();
    if (status != ZX.OK) {
      throw fidl.MethodException(status);
    }
  }

  @override
  Future<NodeInfo> describe() async => file.describe();

  @override
  Future<ConnectionInfo> describe2(ConnectionInfoQuery query) async =>
      file.describe2(query);

  @override
  Future<File$GetAttr$Response> getAttr() async {
    return File$GetAttr$Response(
        ZX.OK,
        NodeAttributes(
            mode: modeTypeFile | modeProtectionMask,
            id: inoUnknown,
            contentSize: 0,
            storageSize: 0,
            linkCount: 1,
            creationTime: 0,
            modificationTime: 0));
  }

  @override
  Future<File$GetFlags$Response> getFlags() async {
    return File$GetFlags$Response(ZX.OK, flags);
  }

  @override
  Future<File$GetFlagsDeprecatedUseNode$Response>
      getFlagsDeprecatedUseNode() async {
    return File$GetFlagsDeprecatedUseNode$Response(ZX.OK, flags);
  }

  @override
  Future<File$GetBufferDeprecatedUseGetBackingMemory$Response>
      getBufferDeprecatedUseGetBackingMemory(VmoFlags flags) async {
    return File$GetBufferDeprecatedUseGetBackingMemory$Response(
        ZX.ERR_NOT_SUPPORTED, null);
  }

  @override
  Future<Vmo> getBackingMemory(VmoFlags flags) async {
    throw fidl.MethodException(ZX.ERR_NOT_SUPPORTED);
  }

  @override
  Future<File$ReadDeprecated$Response> readDeprecated(int count) async {
    final response = _handleRead(count, seekPos);
    if (response.s == ZX.OK) {
      seekPos += response.data.length;
    }
    return response;
  }

  @override
  Future<Uint8List> read(int count) async {
    final response = _handleRead(count, seekPos);
    if (response.s != ZX.OK) {
      throw fidl.MethodException(response.s);
    }
    seekPos += response.data.length;
    return response.data;
  }

  @override
  Future<File$ReadAtDeprecated$Response> readAtDeprecated(
      int count, int offset) async {
    final response = _handleRead(count, offset);
    return File$ReadAtDeprecated$Response(response.s, response.data);
  }

  @override
  Future<Uint8List> readAt(int count, int offset) async {
    final response = _handleRead(count, offset);
    if (response.s != ZX.OK) {
      throw fidl.MethodException(response.s);
    }
    return response.data;
  }

  @override
  Future<File$SeekDeprecated$Response> seekDeprecated(
      int offset, SeekOrigin seek) async {
    return _handleSeek(seek, offset);
  }

  @override
  Future<int> seek(SeekOrigin seek, int offset) async {
    final response = _handleSeek(seek, offset);
    if (response.s != ZX.OK) {
      throw fidl.MethodException(response.s);
    }
    return response.offset;
  }

  File$SeekDeprecated$Response _handleSeek(SeekOrigin origin, int offset) {
    var calculatedOffset = offset;
    switch (origin) {
      case SeekOrigin.start:
        calculatedOffset = offset;
        break;
      case SeekOrigin.current:
        calculatedOffset = seekPos + offset;
        break;
      case SeekOrigin.end:
        calculatedOffset = (_currentLen - 1) + offset;
        break;
      default:
        return File$SeekDeprecated$Response(ZX.ERR_INVALID_ARGS, 0);
    }
    if (calculatedOffset > _currentLen || calculatedOffset < 0) {
      return File$SeekDeprecated$Response(ZX.ERR_OUT_OF_RANGE, seekPos);
    }
    seekPos = calculatedOffset;
    return File$SeekDeprecated$Response(ZX.OK, seekPos);
  }

  @override
  Future<int> setAttr(
      NodeAttributeFlags flags, NodeAttributes attributes) async {
    return ZX.ERR_NOT_SUPPORTED;
  }

  @override
  Future<int> setFlags(OpenFlags flags) async {
    return ZX.ERR_NOT_SUPPORTED;
  }

  @override
  Future<int> setFlagsDeprecatedUseNode(OpenFlags flags) async {
    return await setFlags(flags);
  }

  @override
  Future<int> syncDeprecated() async {
    return ZX.ERR_NOT_SUPPORTED;
  }

  @override
  Future<void> sync() async {
    throw fidl.MethodException(ZX.ERR_NOT_SUPPORTED);
  }

  @override
  Future<int> truncateDeprecatedUseResize(int length) async {
    return _handleResize(length);
  }

  @override
  Future<void> resize(int length) async {
    int status = _handleResize(length);
    if (status != ZX.OK) {
      throw fidl.MethodException(status);
    }
  }

  int _handleResize(int length) {
    if ((flags & OpenFlags.rightWritable) == OpenFlags.$none) {
      return ZX.ERR_ACCESS_DENIED;
    }
    if (file._writeFn == null) {
      return ZX.ERR_NOT_SUPPORTED;
    }
    if (length > _currentLen) {
      return ZX.ERR_OUT_OF_RANGE;
    }

    _currentLen = length;
    seekPos = min(seekPos, _currentLen);
    _wasWritten = true;
    return ZX.OK;
  }

  @override
  Future<File$WriteDeprecated$Response> writeDeprecated(Uint8List data) async {
    final response = _handleWrite(seekPos, data);
    if (response.s == ZX.OK) {
      seekPos += response.actual;
    }
    return response;
  }

  @override
  Future<int> write(Uint8List data) async {
    final response = _handleWrite(seekPos, data);
    if (response.s != ZX.OK) {
      throw fidl.MethodException(response.s);
    }
    seekPos += response.actual;
    return response.actual;
  }

  @override
  Future<File$WriteAtDeprecated$Response> writeAtDeprecated(
      Uint8List data, int offset) async {
    final response = _handleWrite(offset, data);
    return File$WriteAtDeprecated$Response(response.s, response.actual);
  }

  @override
  Future<int> writeAt(Uint8List data, int offset) async {
    final response = _handleWrite(offset, data);
    if (response.s != ZX.OK) {
      throw fidl.MethodException(response.s);
    }
    return response.actual;
  }

  File$ReadDeprecated$Response _handleRead(int count, int offset) {
    if ((flags & OpenFlags.rightReadable) == OpenFlags.$none) {
      return File$ReadDeprecated$Response(ZX.ERR_ACCESS_DENIED, Uint8List(0));
    }
    if (file._readFn == null) {
      return File$ReadDeprecated$Response(ZX.ERR_NOT_SUPPORTED, Uint8List(0));
    }
    if (offset == _currentLen) {
      return File$ReadDeprecated$Response(ZX.OK, Uint8List(0));
    }
    if (offset > _currentLen) {
      return File$ReadDeprecated$Response(ZX.ERR_OUT_OF_RANGE, Uint8List(0));
    }

    var c = count;
    if (count + offset > _currentLen) {
      c = _currentLen - offset;
      if (c < 0) {
        c = 0;
      }
    }
    final b = Uint8List.view(_buffer.buffer, offset, c);
    return File$ReadDeprecated$Response(ZX.OK, b);
  }

  File$WriteDeprecated$Response _handleWrite(int offset, Uint8List data) {
    if ((flags & OpenFlags.rightWritable) == OpenFlags.$none) {
      return File$WriteDeprecated$Response(ZX.ERR_ACCESS_DENIED, 0);
    }
    if (file._writeFn == null) {
      return File$WriteDeprecated$Response(ZX.ERR_NOT_SUPPORTED, 0);
    }
    if (offset >= capacity) {
      return File$WriteDeprecated$Response(ZX.ERR_OUT_OF_RANGE, 0);
    }
    if (offset > _currentLen) {
      return File$WriteDeprecated$Response(ZX.ERR_OUT_OF_RANGE, 0);
    }

    final actual = min(data.length, capacity - offset);
    _buffer.setRange(offset, offset + actual, data.getRange(0, actual));
    _wasWritten = true;
    _currentLen = offset + actual;
    return File$WriteDeprecated$Response(ZX.OK, actual);
  }

  @override
  Future<File$QueryFilesystem$Response> queryFilesystem() async {
    return File$QueryFilesystem$Response(ZX.ERR_NOT_SUPPORTED, null);
  }
}
