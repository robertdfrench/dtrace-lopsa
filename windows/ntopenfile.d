#!/usr/sbin/dtrace -s
syscall::NtOpenFile:entry { printf("%s", execname); }
