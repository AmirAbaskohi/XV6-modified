#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"

int main()
{
    for (int i = 0; i < 10; i++)
    {
        int p = fork();
        if (p < 0)
        {
            printf(1, "fork error\n");
            exit();
        }
        if (p == 0)
        {
            for(int i = 0 ; i < 20000 * 30 ; i++)
            {
                delay(2000000000);
            }
            exit();
        }
        
    }
    wait();
    wait();
    wait();
    wait();
    wait();
    wait();
    wait();
    wait();
    wait();
    wait();

    exit();
}