#include "types.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char* argv[])
{
    if (argc < 3)
    {
        printf(1 , "Not enough arguments\n");
        exit();
    }
    set_ticket(atoi(argv[1]), atoi(argv[2]));
    exit();
}