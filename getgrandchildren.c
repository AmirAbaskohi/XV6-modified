#include "types.h"
#include "user.h"
#include "fcntl.h"

int main()
{
    int p1 = fork();
    if(p1<0) exit();
    else if(p1 == 0) {
        get_grandchildren(1);
    }
    else
        wait();
    exit();
}
