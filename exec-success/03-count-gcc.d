#!/usr/sbin/dtrace -s
int num_gcc_invocations;
proc:::exec-success /execname == "gcc"/ { num_gcc_invocations += 1 }
dtrace:::END { printf("Gcc was called %d times\n", num_gcc_invocations) }
