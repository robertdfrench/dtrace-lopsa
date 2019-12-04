#!/usr/sbin/dtrace -s
proc:::exec-success { printf("%s", curpsinfo->pr_psargs); }
