#!/usr/sbin/dtrace -s
python*:::function-entry /copyinstr(arg1) == $$1/ {
	printf("%s:%s:%d\n", basename(copyinstr(arg0)), copyinstr(arg1), arg2)
}
