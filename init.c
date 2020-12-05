// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char *argv[] = { "sh", 0 };

int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  pid = fork();
  if(pid < 0){
    printf(1, "trace_syscalls: fork failed\n");
    exit();
  }
  if(pid == 0){
    for(;;){
    trace_syscalls(0);
    sleep(505);
    }
    printf(1, "trace_syscalls: exec sh failed\n");
    exit();
  }


  for(;;){
    printf(1, "init: starting sh\n");
    printf(1,"Sina Salimian\n");
    printf(1,"Amirhossein Abbaskuhi\n");
    printf(1,"Arash Rasouli\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
