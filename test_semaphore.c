#include "types.h"
#include "user.h"
#include "fcntl.h"

#define BUFFER_SIZE 3

struct spinlock1 lk;

void Producer()
{

    int produced;
    for(produced=0;produced<10;produced++)
    {
        semaphore_aquire(2);//empty


        semaphore_aquire(0);//mutex
            printf(1, "write\n");
        semaphore_release(0);//mutex


        semaphore_release(1);//full
    }
}

void Consumer()
{
    int consumed;
    
    for(consumed=0;consumed<10;consumed++)
    {
        semaphore_aquire(1);//full
        

        semaphore_aquire(0);//mutex
            printf(1, "read\n");
        semaphore_release(0);//mutex


        semaphore_release(2);//empty
    }
}

int main()
{
    semaphore_initialize(0, 1, 0);//lock
    semaphore_initialize(1, BUFFER_SIZE, BUFFER_SIZE);//full
    semaphore_initialize(2, BUFFER_SIZE, 0);//empty

    init_lock(&lk);
    
    int pid = fork();
    if (pid < 0)
    {
        printf(1, "fork error\n");
    }
    else if (pid == 0)
    {
        Producer();
        exit();
    }
    else 
    {
        Consumer();
        wait();
    }
    

    // semaphore_release(1);

    // semaphore_aquire(1);
    //  printf(1, "hello");
    // semaphore_release(1);
  
    exit();
    
}

