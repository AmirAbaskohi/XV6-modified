#include "types.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char* argv[])
{
    if (argc < 4)
    {
        printf(1 , "Not enough arguments\n");
        exit();
    }
    set_ratio_system(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]));
    exit();
}