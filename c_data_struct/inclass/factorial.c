#include <stdio.h>

int factorial(int n)
{
    if (!n) {
        return 1;
    }

    return n * factorial(n-1);
}

int main(void)
{
    int i = 5;
    int r = factorial(i);

    printf("%i factorial is: %i\n", i, r);

    return 0;
}