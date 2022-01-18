#include <stdio.h>
#include <string.h>

int main(void)
{
    // Write a program to determine the byte width of an unsigned long int

    int i;
    char chars[256];
    unsigned short longs[2];

    longs[0] = 0lu;
    longs[1] = ~0lu;

    memcpy(chars, longs, sizeof(unsigned long) * 2);

    i = 0;
    while (chars[i] == 0)
    {
        ++i;
    }
    

    printf("The value of i: %i\n", i);
    printf("The size of unsigned short: %lu\n", sizeof(unsigned short));

    return 0;
}