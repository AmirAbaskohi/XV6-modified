#include "types.h"
#include "user.h"
#include "fcntl.h"

int main()
{
    int pid = fork();
    if (pid < 0)
    {
        printf(1, "Error forking first child.\n");
    }
    else if (pid == 0)
    {
        printf(1, "Child 1 Executing\n");
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