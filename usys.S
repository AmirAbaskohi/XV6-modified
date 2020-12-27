#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(reverse_number)
SYSCALL(trace_syscalls)
SYSCALL(get_children)
SYSCALL(get_grandchildren)
SYSCALL(getpid_parent)
SYSCALL(change_queue)
SYSCALL(set_ticket)
SYSCALL(set_ratio_process)
SYSCALL(set_ratio_system)
SYSCALL(print_processes_datails)
SYSCALL(semaphore_initialize)
SYSCALL(semaphore_aquire)
SYSCALL(semaphore_release)
SYSCALL(cv_wait)
SYSCALL(cv_signal)
SYSCALL(reader)
SYSCALL(writer)
SYSCALL(init_rwp)