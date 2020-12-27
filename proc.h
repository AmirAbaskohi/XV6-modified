// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;


struct spinlock1 {
  uint locked;
};

struct condvar
{
    int active;
    struct spinlock1 lock;
};

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};
void show_syscalls(void);
void set_state(int _state);
void show_children(int parent_pid);
void show_grandchildren(int parent_pid);
void change_sched_queue(int pid, int dst_queue);
void set_ticket(int pid, int tickets);
void set_ratio_process(int pid, int priority_ratio, int arrival_time_ratio, int executed_cycle_ratio);
void set_ratio_system(int priority_ratio, int arrival_time_ratio, int executed_cycle_ratio);
void print_processes_datails(void);
void sem_init(int sem, int size, int processes_inside);
void sem_wait(int sem);
void sem_signal(int sem);

void cv_wait(struct condvar* cv);
void cv_signal(struct condvar* cv);

void writer(int id);
void reader(int id);
void init_rwp();

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };


// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16]; 
  int syscalls[23] ;

  int sched_queue;
  int tickets;

  long int arrival_time;
  int executed_cycle;
  long int waiting_time;

  int priority_ratio;
  int arrival_time_ratio;
  int executed_cycle_ratio;
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap

