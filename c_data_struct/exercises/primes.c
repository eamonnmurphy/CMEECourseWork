#include <stdio.h>
#include <stdlib.h>

int count_primes(int n)
{
    int loc = 2;
    int count = 0;

    while (loc < n)
    {
        for (size_t div = 2; div <= loc; div++)
        {
            if (loc % div == 0 && loc == div)
            {
                count++;
            }
            else if (loc % div == 0)
            {
                break;
            }
        }
        loc++;
    }

    printf("There are %i primes below %i\n", count, n);

    return 0;
}

int main(int argc, char* argv[])
{
    int limit;
    int ret;

    if (argc == 2)
    {
        limit = atoi(argv[1]);
        ret = count_primes(limit);
    }
    else if (argc == 1)
    {
        printf("This program counts primes below a limit, which must be inputted\n");
        ret = 0;
    }

    return ret;
}