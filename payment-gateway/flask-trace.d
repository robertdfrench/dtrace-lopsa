#!/usr/sbin/dtrace -s
#pragma D option quiet

self int indent;

python*:::function-entry
/copyinstr(arg1) == $$1/
{
        self->trace = 1;
}

python*:::function-entry
/self->trace/
{
        printf("%d ", timestamp);
        printf("%*s", self->indent, "");
        printf("%s:%s:%d\n", copyinstr(arg0), copyinstr(arg1), arg2);
        self->indent++;
}

python*:::function-return
/self->trace/
{
        self->indent--;
        printf("%d ", timestamp);
        printf("%*s", self->indent, "");
        printf("%s:%s:%d\n", copyinstr(arg0), copyinstr(arg1), arg2);
}

python*:::function-return
/copyinstr(arg1) == $$1/
{
        self->trace = 0;
}
