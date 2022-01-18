#include <stdio.h>
#include <stdlib.h>

void doubler(int* i)
{
    // i *= 2;
    // return i;

    // express using pointer syntax
    *i = *i * 2;
}

int main(void)
{
    int x;
    int* xp;

    xp = NULL;

    printf("xp before assignment: %p\n", xp);

    xp = &x;

    printf("x before initialisation: %i\n", x);

    *xp = 7;

    printf("x after init: %i\n", x);

    doubler(xp);

    printf("x after doubling: %i\n", x);

    return 0;
}