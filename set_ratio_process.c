#include "types.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char* argv[])
{
    if (argc < 5)
    {
        printf(1 , "Not enough arguments\n");
        exit();
    }
    set_ratio_process(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]));
    exit();
}