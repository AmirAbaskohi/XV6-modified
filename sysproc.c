#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_reverse_number(void)
{
  struct proc *curproc = myproc();
  int number = curproc->tf->edx;
  int reverse =0;

  while(number > 0) 
    { 
        reverse = reverse*10 + number%10; 
        number = number/10; 
    } 
    cprintf("Reverse number is : %d\n",reverse);
    return 1; 
}

int sys_trace_syscalls(void)
{
  int state;
  struct proc *curproc = myproc();

  if(argint(0, &state) < 0)
    return -1;
  if(curproc->pid == 2)
  {
    show_syscalls();
  }
  else
  set_state(state);

  return 1;
}

int sys_get_children(void)
{
  int parent_id;

  if(argint(0, &parent_id) < 0)
    return -1;
  show_children(parent_id);
  return 1;
}

int sys_get_grandchildren(void)
{
  int parent_id;

  if(argint(0, &parent_id) < 0)
    return -1;
  show_grandchildren(parent_id);
  return 1;
}

int
sys_getpid_parent(void)
{
  return myproc()->parent->pid;
}
