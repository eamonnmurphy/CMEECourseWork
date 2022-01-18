#include <stdio.h>

int x = 1;
int y;

int main(void)
{
    char x = 4;

    {
        int x = 5;
    }
    
    printf("The value of x: %i\n", x);
    printf("The value of y: %i\n", x);

    return 0;
}