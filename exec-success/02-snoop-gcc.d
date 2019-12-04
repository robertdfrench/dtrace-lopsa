#!/usr/sbin/dtrace -s
proc:::exec-success /execname == "gcc"/ { printf("%s", curpsinfo->pr_psargs); }
