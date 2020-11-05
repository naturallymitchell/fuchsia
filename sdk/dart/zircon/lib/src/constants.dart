// Copyright 2018 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of zircon;

// This is autogenerated from Zircon headers. Do not edit directly.
// Generated by //topaz/public/dart/zircon/extract-zircon-constants.py

// ignore_for_file: constant_identifier_names
// ignore_for_file: public_member_api_docs
abstract class ZX {
  ZX._();
  static const int OK = 0;
  static const int ERR_INTERNAL = -1;
  static const int ERR_NOT_SUPPORTED = -2;
  static const int ERR_NO_RESOURCES = -3;
  static const int ERR_NO_MEMORY = -4;
  static const int ERR_INTERNAL_INTR_RETRY = -6;
  static const int ERR_INVALID_ARGS = -10;
  static const int ERR_BAD_HANDLE = -11;
  static const int ERR_WRONG_TYPE = -12;
  static const int ERR_BAD_SYSCALL = -13;
  static const int ERR_OUT_OF_RANGE = -14;
  static const int ERR_BUFFER_TOO_SMALL = -15;
  static const int ERR_BAD_STATE = -20;
  static const int ERR_TIMED_OUT = -21;
  static const int ERR_SHOULD_WAIT = -22;
  static const int ERR_CANCELED = -23;
  static const int ERR_PEER_CLOSED = -24;
  static const int ERR_NOT_FOUND = -25;
  static const int ERR_ALREADY_EXISTS = -26;
  static const int ERR_ALREADY_BOUND = -27;
  static const int ERR_UNAVAILABLE = -28;
  static const int ERR_ACCESS_DENIED = -30;
  static const int ERR_IO = -40;
  static const int ERR_IO_REFUSED = -41;
  static const int ERR_IO_DATA_INTEGRITY = -42;
  static const int ERR_IO_DATA_LOSS = -43;
  static const int ERR_IO_NOT_PRESENT = -44;
  static const int ERR_IO_OVERRUN = -45;
  static const int ERR_IO_MISSED_DEADLINE = -46;
  static const int ERR_IO_INVALID = -47;
  static const int ERR_BAD_PATH = -50;
  static const int ERR_NOT_DIR = -51;
  static const int ERR_NOT_FILE = -52;
  static const int ERR_FILE_BIG = -53;
  static const int ERR_NO_SPACE = -54;
  static const int ERR_NOT_EMPTY = -55;
  static const int ERR_STOP = -60;
  static const int ERR_NEXT = -61;
  static const int ERR_ASYNC = -62;
  static const int ERR_PROTOCOL_NOT_SUPPORTED = -70;
  static const int ERR_ADDRESS_UNREACHABLE = -71;
  static const int ERR_ADDRESS_IN_USE = -72;
  static const int ERR_NOT_CONNECTED = -73;
  static const int ERR_CONNECTION_REFUSED = -74;
  static const int ERR_CONNECTION_RESET = -75;
  static const int ERR_CONNECTION_ABORTED = -76;
  static const int HANDLE_INVALID = 0;
  static const int HANDLE_FIXED_BITS_MASK = 0x3;
  static const int CLOCK_MONOTONIC = 0;
  static const int CLOCK_UTC = 1;
  static const int CLOCK_THREAD = 2;
  static const int SIGNAL_NONE = 0;
  static const int USER_SIGNAL_ALL = 0xff000000;
  static const int USER_SIGNAL_0 = 1 << 24;
  static const int USER_SIGNAL_1 = 1 << 25;
  static const int USER_SIGNAL_2 = 1 << 26;
  static const int USER_SIGNAL_3 = 1 << 27;
  static const int USER_SIGNAL_4 = 1 << 28;
  static const int USER_SIGNAL_5 = 1 << 29;
  static const int USER_SIGNAL_6 = 1 << 30;
  static const int USER_SIGNAL_7 = 1 << 31;
  static const int SIGNAL_HANDLE_CLOSED = __ZX_OBJECT_HANDLE_CLOSED;
  static const int EVENT_SIGNALED = __ZX_OBJECT_SIGNALED;
  static const int EVENT_SIGNAL_MASK = USER_SIGNAL_ALL | __ZX_OBJECT_SIGNALED;
  static const int EVENTPAIR_SIGNALED = __ZX_OBJECT_SIGNALED;
  static const int EVENTPAIR_PEER_CLOSED = __ZX_OBJECT_PEER_CLOSED;
  static const int EVENTPAIR_SIGNAL_MASK =
      USER_SIGNAL_ALL | __ZX_OBJECT_SIGNALED | __ZX_OBJECT_PEER_CLOSED;
  static const int CHANNEL_READABLE = __ZX_OBJECT_READABLE;
  static const int CHANNEL_WRITABLE = __ZX_OBJECT_WRITABLE;
  static const int CHANNEL_PEER_CLOSED = __ZX_OBJECT_PEER_CLOSED;
  static const int SOCKET_READABLE = __ZX_OBJECT_READABLE;
  static const int SOCKET_WRITABLE = __ZX_OBJECT_WRITABLE;
  static const int SOCKET_PEER_CLOSED = __ZX_OBJECT_PEER_CLOSED;
  static const int SOCKET_PEER_WRITE_DISABLED = __ZX_OBJECT_SIGNAL_4;
  static const int SOCKET_WRITE_DISABLED = __ZX_OBJECT_SIGNAL_5;
  static const int SOCKET_CONTROL_READABLE = __ZX_OBJECT_SIGNAL_6;
  static const int SOCKET_CONTROL_WRITABLE = __ZX_OBJECT_SIGNAL_7;
  static const int SOCKET_ACCEPT = __ZX_OBJECT_SIGNAL_8;
  static const int SOCKET_SHARE = __ZX_OBJECT_SIGNAL_9;
  static const int SOCKET_READ_THRESHOLD = __ZX_OBJECT_SIGNAL_10;
  static const int SOCKET_WRITE_THRESHOLD = __ZX_OBJECT_SIGNAL_11;
  static const int SOCKET_READ_DISABLED = SOCKET_PEER_WRITE_DISABLED;
  static const int FIFO_READABLE = __ZX_OBJECT_READABLE;
  static const int FIFO_WRITABLE = __ZX_OBJECT_WRITABLE;
  static const int FIFO_PEER_CLOSED = __ZX_OBJECT_PEER_CLOSED;
  static const int TASK_TERMINATED = __ZX_OBJECT_SIGNALED;
  static const int JOB_NO_JOBS = __ZX_OBJECT_SIGNAL_4;
  static const int JOB_NO_PROCESSES = __ZX_OBJECT_SIGNAL_5;
  static const int PROCESS_TERMINATED = __ZX_OBJECT_SIGNALED;
  static const int THREAD_TERMINATED = __ZX_OBJECT_SIGNALED;
  static const int THREAD_RUNNING = __ZX_OBJECT_SIGNAL_4;
  static const int THREAD_SUSPENDED = __ZX_OBJECT_SIGNAL_5;
  static const int LOG_READABLE = __ZX_OBJECT_READABLE;
  static const int LOG_WRITABLE = __ZX_OBJECT_WRITABLE;
  static const int TIMER_SIGNALED = __ZX_OBJECT_SIGNALED;
  static const int VMO_ZERO_CHILDREN = __ZX_OBJECT_SIGNALED;
  static const int KOID_INVALID = 0;
  static const int KOID_KERNEL = 1;
  static const int KOID_FIRST = 1024;
  static const int WAIT_MANY_MAX_ITEMS = 16;
  static const int VMO_NON_RESIZABLE = 1;
  static const int VMO_OP_COMMIT = 1;
  static const int VMO_OP_DECOMMIT = 2;
  static const int VMO_OP_LOCK = 3;
  static const int VMO_OP_UNLOCK = 4;
  static const int VMO_OP_CACHE_SYNC = 6;
  static const int VMO_OP_CACHE_INVALIDATE = 7;
  static const int VMO_OP_CACHE_CLEAN = 8;
  static const int VMO_OP_CACHE_CLEAN_INVALIDATE = 9;
  static const int VMO_CLONE_COPY_ON_WRITE = 1 << 0;
  static const int VMO_CLONE_NON_RESIZEABLE = 1 << 1;
  static const int VM_PERM_READ = (1 << 0);
  static const int VM_PERM_WRITE = (1 << 1);
  static const int VM_PERM_EXECUTE = (1 << 2);
  static const int VM_COMPACT = (1 << 3);
  static const int VM_SPECIFIC = (1 << 4);
  static const int VM_SPECIFIC_OVERWRITE = (1 << 5);
  static const int VM_CAN_MAP_SPECIFIC = (1 << 6);
  static const int VM_CAN_MAP_READ = (1 << 7);
  static const int VM_CAN_MAP_WRITE = (1 << 8);
  static const int VM_CAN_MAP_EXECUTE = (1 << 9);
  static const int VM_MAP_RANGE = (1 << 10);
  static const int VM_REQUIRE_NON_RESIZABLE = (1 << 11);
  static const int MAX_NAME_LEN = 32;
  static const int CPRNG_DRAW_MAX_LEN = 256;
  static const int CPRNG_ADD_ENTROPY_MAX_LEN = 256;
  static const int INTERRUPT_REMAP_IRQ = 0x1;
  static const int INTERRUPT_MODE_DEFAULT = 0 << 1;
  static const int INTERRUPT_MODE_EDGE_LOW = 1 << 1;
  static const int INTERRUPT_MODE_EDGE_HIGH = 2 << 1;
  static const int INTERRUPT_MODE_LEVEL_LOW = 3 << 1;
  static const int INTERRUPT_MODE_LEVEL_HIGH = 4 << 1;
  static const int INTERRUPT_MODE_EDGE_BOTH = 5 << 1;
  static const int INTERRUPT_MODE_MASK = 0xe;
  static const int INTERRUPT_VIRTUAL = 0x10;
  static const int INTERRUPT_SLOT_USER = 62;
  static const int INTERRUPT_MAX_SLOTS = 62;
  static const int PCI_INTERRUPT_SLOT = 0;
  static const int CHANNEL_READ_MAY_DISCARD = 1;
  static const int CHANNEL_MAX_MSG_BYTES = 65536;
  static const int CHANNEL_MAX_MSG_HANDLES = 64;
  static const int SOCKET_SHUTDOWN_WRITE = 1 << 0;
  static const int SOCKET_SHUTDOWN_READ = 1 << 1;
  static const int SOCKET_SHUTDOWN_MASK =
      SOCKET_SHUTDOWN_WRITE | SOCKET_SHUTDOWN_READ;
  static const int SOCKET_STREAM = 0;
  static const int SOCKET_DATAGRAM = 1 << 0;
  static const int SOCKET_HAS_CONTROL = 1 << 1;
  static const int SOCKET_HAS_ACCEPT = 1 << 2;
  static const int SOCKET_CREATE_MASK =
      SOCKET_DATAGRAM | SOCKET_HAS_CONTROL | SOCKET_HAS_ACCEPT;
  static const int SOCKET_CONTROL = 1 << 2;
  static const int SOCKET_PEEK = 1 << 3;
  static const int CACHE_POLICY_CACHED = 0;
  static const int CACHE_POLICY_UNCACHED = 1;
  static const int CACHE_POLICY_UNCACHED_DEVICE = 2;
  static const int CACHE_POLICY_WRITE_COMBINING = 3;
  static const int CACHE_POLICY_MASK = 3;
  static const int CACHE_FLUSH_INSN = 1 << 0;
  static const int CACHE_FLUSH_DATA = 1 << 1;
  static const int CACHE_FLUSH_INVALIDATE = 1 << 2;
  static const int TIMER_SLACK_CENTER = 0;
  static const int TIMER_SLACK_EARLY = 1;
  static const int TIMER_SLACK_LATE = 2;
  static const int BTI_PERM_READ = 1 << 0;
  static const int BTI_PERM_WRITE = 1 << 1;
  static const int BTI_PERM_EXECUTE = 1 << 2;
  static const int BTI_COMPRESS = 1 << 3;
  static const int BTI_CONTIGUOUS = 1 << 4;
  static const int OBJ_TYPE_NONE = 0;
  static const int OBJ_TYPE_PROCESS = 1;
  static const int OBJ_TYPE_THREAD = 2;
  static const int OBJ_TYPE_VMO = 3;
  static const int OBJ_TYPE_CHANNEL = 4;
  static const int OBJ_TYPE_EVENT = 5;
  static const int OBJ_TYPE_PORT = 6;
  static const int OBJ_TYPE_INTERRUPT = 9;
  static const int OBJ_TYPE_PCI_DEVICE = 11;
  static const int OBJ_TYPE_LOG = 12;
  static const int OBJ_TYPE_SOCKET = 14;
  static const int OBJ_TYPE_RESOURCE = 15;
  static const int OBJ_TYPE_EVENTPAIR = 16;
  static const int OBJ_TYPE_JOB = 17;
  static const int OBJ_TYPE_VMAR = 18;
  static const int OBJ_TYPE_FIFO = 19;
  static const int OBJ_TYPE_GUEST = 20;
  static const int OBJ_TYPE_VCPU = 21;
  static const int OBJ_TYPE_TIMER = 22;
  static const int OBJ_TYPE_IOMMU = 23;
  static const int OBJ_TYPE_BTI = 24;
  static const int OBJ_TYPE_PROFILE = 25;
  static const int OBJ_TYPE_PMT = 26;
  static const int OBJ_TYPE_SUSPEND_TOKEN = 27;
  static const int OBJ_TYPE_PAGER = 28;
  static const int OBJ_TYPE_EXCEPTION = 29;
  static const int OBJ_TYPE_UPPER_BOUND = 64;
  static const int HANDLE_OP_MOVE = 0;
  static const int HANDLE_OP_DUPLICATE = 1;
  static const int VM_FLAG_PERM_READ = 1 << 0;
  static const int VM_FLAG_PERM_WRITE = 1 << 1;
  static const int VM_FLAG_PERM_EXECUTE = 1 << 2;
  static const int VM_FLAG_COMPACT = 1 << 3;
  static const int VM_FLAG_SPECIFIC = 1 << 4;
  static const int VM_FLAG_SPECIFIC_OVERWRITE = 1 << 5;
  static const int VM_FLAG_CAN_MAP_SPECIFIC = 1 << 6;
  static const int VM_FLAG_CAN_MAP_READ = 1 << 7;
  static const int VM_FLAG_CAN_MAP_WRITE = 1 << 8;
  static const int VM_FLAG_CAN_MAP_EXECUTE = 1 << 9;
  static const int VM_FLAG_MAP_RANGE = 1 << 10;
  static const int VM_FLAG_REQUIRE_NON_RESIZABLE = 1 << 11;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_ALL = 0x00ffffff;
  // ignore: unused_field
  static const int __ZX_OBJECT_READABLE = 1 << 0;
  // ignore: unused_field
  static const int __ZX_OBJECT_WRITABLE = 1 << 1;
  // ignore: unused_field
  static const int __ZX_OBJECT_PEER_CLOSED = 1 << 2;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNALED = 1 << 3;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_4 = 1 << 4;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_5 = 1 << 5;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_6 = 1 << 6;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_7 = 1 << 7;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_8 = 1 << 8;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_9 = 1 << 9;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_10 = 1 << 10;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_11 = 1 << 11;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_12 = 1 << 12;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_13 = 1 << 13;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_14 = 1 << 14;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_15 = 1 << 15;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_16 = 1 << 16;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_17 = 1 << 17;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_18 = 1 << 18;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_19 = 1 << 19;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_20 = 1 << 20;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_21 = 1 << 21;
  // ignore: unused_field
  static const int __ZX_OBJECT_SIGNAL_22 = 1 << 22;
  // ignore: unused_field
  static const int __ZX_OBJECT_HANDLE_CLOSED = 1 << 23;
  // ignore: unused_field
  static const int __ZX_JOB_NO_PROCESSES_OLD = __ZX_OBJECT_SIGNALED;
  static const int RIGHT_NONE = 0;
  static const int RIGHT_DUPLICATE = 1 << 0;
  static const int RIGHT_TRANSFER = 1 << 1;
  static const int RIGHT_READ = 1 << 2;
  static const int RIGHT_WRITE = 1 << 3;
  static const int RIGHT_EXECUTE = 1 << 4;
  static const int RIGHT_MAP = 1 << 5;
  static const int RIGHT_GET_PROPERTY = 1 << 6;
  static const int RIGHT_SET_PROPERTY = 1 << 7;
  static const int RIGHT_ENUMERATE = 1 << 8;
  static const int RIGHT_DESTROY = 1 << 9;
  static const int RIGHT_SET_POLICY = 1 << 10;
  static const int RIGHT_GET_POLICY = 1 << 11;
  static const int RIGHT_SIGNAL = 1 << 12;
  static const int RIGHT_SIGNAL_PEER = 1 << 13;
  static const int RIGHT_WAIT = 1 << 14;
  static const int RIGHT_INSPECT = 1 << 15;
  static const int RIGHT_MANAGE_JOB = 1 << 16;
  static const int RIGHT_MANAGE_PROCESS = 1 << 17;
  static const int RIGHT_MANAGE_THREAD = 1 << 18;
  static const int RIGHT_APPLY_PROFILE = 1 << 19;
  static const int RIGHT_SAME_RIGHTS = 1 << 31;
  static const int RIGHTS_BASIC =
      RIGHT_TRANSFER | RIGHT_DUPLICATE | RIGHT_WAIT | RIGHT_INSPECT;
  static const int RIGHTS_IO = RIGHT_READ | RIGHT_WRITE;
  static const int RIGHTS_PROPERTY = RIGHT_GET_PROPERTY | RIGHT_SET_PROPERTY;
  static const int RIGHTS_POLICY = RIGHT_GET_POLICY | RIGHT_SET_POLICY;
  static const int DEFAULT_CHANNEL_RIGHTS =
      (RIGHTS_BASIC & (~RIGHT_DUPLICATE)) |
          RIGHTS_IO |
          RIGHT_SIGNAL |
          RIGHT_SIGNAL_PEER;
  static const int DEFAULT_EVENT_RIGHTS = RIGHTS_BASIC | RIGHT_SIGNAL;
  static const int DEFAULT_EVENTPAIR_RIGHTS =
      RIGHTS_BASIC | RIGHT_SIGNAL | RIGHT_SIGNAL_PEER;
  static const int DEFAULT_FIFO_RIGHTS =
      RIGHTS_BASIC | RIGHTS_IO | RIGHT_SIGNAL | RIGHT_SIGNAL_PEER;
  static const int DEFAULT_GUEST_RIGHTS = RIGHT_TRANSFER |
      RIGHT_DUPLICATE |
      RIGHT_WRITE |
      RIGHT_INSPECT |
      RIGHT_MANAGE_PROCESS;
  static const int DEFAULT_INTERRUPT_RIGHTS =
      RIGHTS_BASIC | RIGHTS_IO | RIGHT_SIGNAL;
  static const int DEFAULT_IO_MAPPING_RIGHTS = RIGHT_READ | RIGHT_INSPECT;
  static const int DEFAULT_JOB_RIGHTS = RIGHTS_BASIC |
      RIGHTS_IO |
      RIGHTS_PROPERTY |
      RIGHTS_POLICY |
      RIGHT_ENUMERATE |
      RIGHT_DESTROY |
      RIGHT_SIGNAL |
      RIGHT_MANAGE_JOB |
      RIGHT_MANAGE_PROCESS |
      RIGHT_MANAGE_THREAD;
  static const int DEFAULT_LOG_RIGHTS =
      RIGHTS_BASIC | RIGHT_WRITE | RIGHT_SIGNAL;
  static const int DEFAULT_PCI_DEVICE_RIGHTS = RIGHTS_BASIC | RIGHTS_IO;
  static const int DEFAULT_PCI_INTERRUPT_RIGHTS =
      RIGHTS_BASIC | RIGHTS_IO | RIGHT_SIGNAL;
  static const int DEFAULT_PORT_RIGHTS =
      (RIGHTS_BASIC & (~RIGHT_WAIT)) | RIGHTS_IO;
  static const int DEFAULT_PROCESS_RIGHTS = RIGHTS_BASIC |
      RIGHTS_IO |
      RIGHTS_PROPERTY |
      RIGHT_ENUMERATE |
      RIGHT_DESTROY |
      RIGHT_SIGNAL |
      RIGHT_MANAGE_PROCESS |
      RIGHT_MANAGE_THREAD;
  static const int DEFAULT_RESOURCE_RIGHTS =
      RIGHT_TRANSFER | RIGHT_DUPLICATE | RIGHT_WRITE | RIGHT_INSPECT;
  static const int DEFAULT_SOCKET_RIGHTS = RIGHTS_BASIC |
      RIGHTS_IO |
      RIGHT_GET_PROPERTY |
      RIGHT_SET_PROPERTY |
      RIGHT_SIGNAL |
      RIGHT_SIGNAL_PEER;
  static const int DEFAULT_THREAD_RIGHTS = RIGHTS_BASIC |
      RIGHTS_IO |
      RIGHTS_PROPERTY |
      RIGHT_DESTROY |
      RIGHT_SIGNAL |
      RIGHT_MANAGE_THREAD;
  static const int DEFAULT_TIMER_RIGHTS =
      RIGHTS_BASIC | RIGHT_WRITE | RIGHT_SIGNAL;
  static const int DEFAULT_VCPU_RIGHTS =
      RIGHTS_BASIC | RIGHTS_IO | RIGHT_EXECUTE | RIGHT_SIGNAL;
  static const int DEFAULT_VMAR_RIGHTS = RIGHTS_BASIC & (~RIGHT_WAIT);
  static const int DEFAULT_VMO_RIGHTS =
      RIGHTS_BASIC | RIGHTS_IO | RIGHTS_PROPERTY | RIGHT_MAP | RIGHT_SIGNAL;
  static const int DEFAULT_IOMMU_RIGHTS = RIGHTS_BASIC & (~RIGHT_WAIT);
  static const int DEFAULT_BTI_RIGHTS =
      (RIGHTS_BASIC & (~RIGHT_WAIT)) | RIGHTS_IO | RIGHT_MAP;
  static const int DEFAULT_PROFILE_RIGHTS =
      (RIGHTS_BASIC & (~RIGHT_WAIT)) | RIGHT_APPLY_PROFILE;
  static const int DEFAULT_PMT_RIGHTS = RIGHT_INSPECT;
  static const int DEFAULT_SUSPEND_TOKEN_RIGHTS =
      RIGHT_TRANSFER | RIGHT_INSPECT;
  static const int DEFAULT_PAGER_RIGHTS = RIGHT_INSPECT |
      RIGHT_ENUMERATE |
      RIGHT_GET_PROPERTY |
      RIGHT_SET_PROPERTY |
      RIGHT_TRANSFER;
  static const int DEFAULT_EXCEPTION_RIGHTS =
      RIGHT_TRANSFER | RIGHTS_PROPERTY | RIGHT_INSPECT;
}

String getStringForStatus(int status) {
  switch (status) {
    case ZX.OK:
      return 'OK';
    case ZX.ERR_INTERNAL:
      return 'ERR_INTERNAL';
    case ZX.ERR_NOT_SUPPORTED:
      return 'ERR_NOT_SUPPORTED';
    case ZX.ERR_NO_RESOURCES:
      return 'ERR_NO_RESOURCES';
    case ZX.ERR_NO_MEMORY:
      return 'ERR_NO_MEMORY';
    case ZX.ERR_INTERNAL_INTR_RETRY:
      return 'ERR_INTERNAL_INTR_RETRY';
    case ZX.ERR_INVALID_ARGS:
      return 'ERR_INVALID_ARGS';
    case ZX.ERR_BAD_HANDLE:
      return 'ERR_BAD_HANDLE';
    case ZX.ERR_WRONG_TYPE:
      return 'ERR_WRONG_TYPE';
    case ZX.ERR_BAD_SYSCALL:
      return 'ERR_BAD_SYSCALL';
    case ZX.ERR_OUT_OF_RANGE:
      return 'ERR_OUT_OF_RANGE';
    case ZX.ERR_BUFFER_TOO_SMALL:
      return 'ERR_BUFFER_TOO_SMALL';
    case ZX.ERR_BAD_STATE:
      return 'ERR_BAD_STATE';
    case ZX.ERR_TIMED_OUT:
      return 'ERR_TIMED_OUT';
    case ZX.ERR_SHOULD_WAIT:
      return 'ERR_SHOULD_WAIT';
    case ZX.ERR_CANCELED:
      return 'ERR_CANCELED';
    case ZX.ERR_PEER_CLOSED:
      return 'ERR_PEER_CLOSED';
    case ZX.ERR_NOT_FOUND:
      return 'ERR_NOT_FOUND';
    case ZX.ERR_ALREADY_EXISTS:
      return 'ERR_ALREADY_EXISTS';
    case ZX.ERR_ALREADY_BOUND:
      return 'ERR_ALREADY_BOUND';
    case ZX.ERR_UNAVAILABLE:
      return 'ERR_UNAVAILABLE';
    case ZX.ERR_ACCESS_DENIED:
      return 'ERR_ACCESS_DENIED';
    case ZX.ERR_IO:
      return 'ERR_IO';
    case ZX.ERR_IO_REFUSED:
      return 'ERR_IO_REFUSED';
    case ZX.ERR_IO_DATA_INTEGRITY:
      return 'ERR_IO_DATA_INTEGRITY';
    case ZX.ERR_IO_DATA_LOSS:
      return 'ERR_IO_DATA_LOSS';
    case ZX.ERR_IO_NOT_PRESENT:
      return 'ERR_IO_NOT_PRESENT';
    case ZX.ERR_IO_OVERRUN:
      return 'ERR_IO_OVERRUN';
    case ZX.ERR_IO_MISSED_DEADLINE:
      return 'ERR_IO_MISSED_DEADLINE';
    case ZX.ERR_IO_INVALID:
      return 'ERR_IO_INVALID';
    case ZX.ERR_BAD_PATH:
      return 'ERR_BAD_PATH';
    case ZX.ERR_NOT_DIR:
      return 'ERR_NOT_DIR';
    case ZX.ERR_NOT_FILE:
      return 'ERR_NOT_FILE';
    case ZX.ERR_FILE_BIG:
      return 'ERR_FILE_BIG';
    case ZX.ERR_NO_SPACE:
      return 'ERR_NO_SPACE';
    case ZX.ERR_NOT_EMPTY:
      return 'ERR_NOT_EMPTY';
    case ZX.ERR_STOP:
      return 'ERR_STOP';
    case ZX.ERR_NEXT:
      return 'ERR_NEXT';
    case ZX.ERR_ASYNC:
      return 'ERR_ASYNC';
    case ZX.ERR_PROTOCOL_NOT_SUPPORTED:
      return 'ERR_PROTOCOL_NOT_SUPPORTED';
    case ZX.ERR_ADDRESS_UNREACHABLE:
      return 'ERR_ADDRESS_UNREACHABLE';
    case ZX.ERR_ADDRESS_IN_USE:
      return 'ERR_ADDRESS_IN_USE';
    case ZX.ERR_NOT_CONNECTED:
      return 'ERR_NOT_CONNECTED';
    case ZX.ERR_CONNECTION_REFUSED:
      return 'ERR_CONNECTION_REFUSED';
    case ZX.ERR_CONNECTION_RESET:
      return 'ERR_CONNECTION_RESET';
    case ZX.ERR_CONNECTION_ABORTED:
      return 'ERR_CONNECTION_ABORTED';
    default:
      return '(unknown: $status)';
  }
}
