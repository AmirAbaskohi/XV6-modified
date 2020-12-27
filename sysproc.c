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

int 
sys_reverse_number(void)
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

int 
sys_trace_syscalls(void)
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

int 
sys_get_children(void)
{
  int parent_id;

  if(argint(0, &parent_id) < 0)
    return -1;
  show_children(parent_id);
  return 1;
}

int 
sys_get_grandchildren(void)
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

int 
sys_change_queue(void)
{
  int pid;
  int dst_queue;

  if(argint(0, &pid) < 0)
    return -1;

  if(argint(1, &dst_queue) < 0)
    return -1;
  
  change_sched_queue(pid, dst_queue);
  return 1;
}

int 
sys_set_ticket(void)
{
  int pid;
  int tickets;

  if(argint(0, &pid) < 0)
    return -1;

  if(argint(1, &tickets) < 0)
    return -1;
  
  set_ticket(pid, tickets);
  return 1;
}

int 
sys_set_ratio_process(void)
{
  int pid;
  int priority_ratio;
  int arrival_time_ratio;
  int executed_cycle_ratio;

  if(argint(0, &pid) < 0)
    return -1;

  if(argint(1, &priority_ratio) < 0)
    return -1;

  if(argint(2, &arrival_time_ratio) < 0)
    return -1;

  if(argint(3, &executed_cycle_ratio) < 0)
    return -1;
  
  set_ratio_process(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
  return 1;
}

int 
sys_set_ratio_system(void)
{
  int priority_ratio;
  int arrival_time_ratio;
  int executed_cycle_ratio;

  if(argint(0, &priority_ratio) < 0)
    return -1;

  if(argint(1, &arrival_time_ratio) < 0)
    return -1;

  if(argint(2, &executed_cycle_ratio) < 0)
    return -1;
  
  set_ratio_system(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
  return 1;
}

int 
sys_print_processes_datails(void)
{
  print_processes_datails();
  return 1;
}

int
sys_semaphore_initialize(void)
{
  int index;
  int size;
  int init_processes;

  if(argint(0, &index) < 0)
    return -1;

  if(argint(1, &size) < 0)
    return -1;

  if(argint(2, &init_processes) < 0)
    return -1;
  
  sem_init(index, size, init_processes);
  return 1;
}

int
sys_semaphore_aquire(void)
{
  int index;
  

  if(argint(0, &index) < 0)
    return -1;
  
  sem_wait(index);
  return 1;
}

int
sys_semaphore_release(void)
{
  int index;

  if(argint(0, &index) < 0)
    return -1;
  
  sem_signal(index);
  return 1;
}

int
sys_cv_wait(void)
{
  struct condvar* cv;

  if(argptr(0, (void*)&cv, sizeof(*cv)) < 0)
    return -1;
  
  cv_wait(cv);
  return 1;
}

int
sys_cv_signal(void)
{
  struct condvar* cv;

  if(argptr(0, (void*)&cv, sizeof(*cv)) < 0)
    return -1;
  
  cv_signal(cv);
  return 1;
}


int
sys_reader(void)
{
  int id;

  if(argint(0, &id) < 0)
    return -1;

  reader(id);
  return 1;
}

int
sys_writer(void)
{
  int id;

  if(argint(0, &id) < 0)
    return -1;

  writer(id);
  return 1;
}

int
sys_init_rwp(void)
{
  init_rwp();
  return 1;
}