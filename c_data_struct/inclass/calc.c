#include <stdio.h>

int main(void)
{
    int a;
    int b;
    int c;

    a = 1 + 2;
    b = 2;
    c = a + b;

    printf("The results of a + b using c: %i\n", c);
    printf("The result of a + b: %i\n", a + b);

    return 0;
}