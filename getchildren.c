#include "types.h"
#include "user.h"
#include "fcntl.h"

int main()
{

    int p1 = fork();
    if(p1<0)
        exit();
    while(wait()!=-1){}

    int p2 = fork();
    if(p2<0)
        exit();
    while(wait()!=-1){}

    printf(1,"pid = %d,parent_pid = %d\n",getpid(),getpid_parent());
    get_children(getpid_parent());

    if(getpid() == 4)
    {
        printf(1,"children of pid 1 :\n");
        get_children(1);
    }
    exit();
}
