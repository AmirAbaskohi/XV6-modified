#include "types.h"
#include "user.h"
#include "fcntl.h"

int main(int argc,char *argv[])
{
    int state = atoi(argv[1]);
    trace_syscalls(state);
    exit();
}
