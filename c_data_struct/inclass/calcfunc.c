#include <stdio.h>
#include 

float divide (float num, float denom); // Function prototype

int main(void)
{
    int x, y;
    float f;

    x = 7;
    y = 3;

    f = x / y;

    printf("The result of int division %f\n", f);

    f = divide(x, y);

    printf("The result of division using a function %f\n", f);

    return 0;
}

float divide (float num, float denom)
{
    float res; // Automatic local variable

    res = num / denom;

    return res;
}

void print_alnum_character(char c)
{
    if (!isalnum(c)) {
        printf("Character is not alphanumeric!\n");
        
    }
}