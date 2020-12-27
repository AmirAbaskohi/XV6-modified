#include "types.h"
#include "user.h"
#include "fcntl.h"

int main()
{
    init_rwp();
    int pid = fork();
    if (pid < 0)
    {
        printf(1, "Error forking.\n");
    }
    else if (pid == 0) // readers
    {
        for (int i=0; i < 5; i++)
        {
            pid = fork();
            if (pid < 0)
            {
                printf(1, "Error forking.\n");
            }
            else if (pid == 0)
            {
                reader(i);
                exit();
            }
        }
        for (int i=0; i < 5; i++)
            wait();
    } 
    else //writers
    {
        for (int i=0; i < 2; i++)
        {
            pid = fork();
            if (pid < 0)
            {
                printf(1, "Error forking.\n");
            }
            else if (pid == 0)
            {
                writer(i);
                exit();
            }
        }
        for (int i=0; i < 2; i++)
        {
            wait();
        }
        wait();
    }
    exit();
}