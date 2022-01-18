#include <stdio.h>
#include <unistd.h>

int main(void)
{
    unsigned long i = 2;

    do {
        i *= 2;
        printf("%lu\n", i);
        sleep(1);
    } while(1);

    return 0;
}