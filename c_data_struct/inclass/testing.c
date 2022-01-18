#include <stdio.h>

int main(void) 
{
    unsigned long x = sizeof(long);

    printf("Size of long is:%lu\n", x);

    unsigned long y = sizeof(double);

    printf("Size of double is: %lu\n", y);

    unsigned long z = sizeof(float);

    printf("Size of float is: %lu\n", z);

    return 0;
}