#include "types.h"
#include "user.h"
#include "fcntl.h"

int main()
{
    struct condvar cv1;
    init_lock(&(cv1.lock));

    int pid = fork();
    if (pid < 0)
    {
        printf(1, "Error forking first child.\n");
    }
    else if (pid == 0)
    {
        sleep(10);
        printf(1, "Child 1 Executing\n");

        lock(&(cv1.lock));
        cv_signal(&cv1);
        unlock(&(cv1.lock));
    }
    else
    {
        pid = fork();
        if (pid < 0)
        {
            printf(1, "Error forking second child.\n");
        }
        else if (pid == 0)
        {
            lock(&(cv1.lock));
            cv_wait(&cv1);
            unlock(&(cv1.lock));

            printf(1, "Child 2 Executing\n");
        }
        else
        {
            int i;
            for(i = 0; i < 2; i++)
                wait();
        } 
    }

    exit();
}