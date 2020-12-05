#include "types.h"
#include "user.h"
#include "fcntl.h"

int gcd(int a, int b)
{
    if(b==0)
        return a;
    return gcd(b, a % b);
}

int lcm(char *arr[], int number_of_arguments)
{
    int i;
    int ans = atoi(arr[1]);
    
    for(i = 2 ; i < number_of_arguments ; i++)
        ans = (((atoi(arr[i]) * ans)) / 
                (gcd(atoi(arr[i]), ans)));
    
    return ans;
}

void save(int result)
{
	static char digits[] = "0123456789ABCDEF";
	char buf[16];
	int i;
	int fd;

	fd = open("lcm_result.txt", O_CREATE | O_RDWR);

	i=0;
	do{
		buf[i++] = digits[result % 10];
	}while((result /= 10) != 0);

	while(--i >= 0)
		write(fd, &buf[i], 1);
}

int main(int argc, char *argv[])
{
    // int res;
    // int number_of_arguments = argc > 9 ? 9 : argc;

    // res = lcm(argv, number_of_arguments);
    // save(res);
    set_ratio_process(getpid(), 1 , 2 , 3);
    exit();
}