#include <stdio.h>

int main(void)
{
    int x; // x is a variable

    x = 0; // 0 is a constant literal

    printf("The value of x is: %i\n", x);

    float y = 1.2; // floating point

    // Integral
    // 0000 : 0
    // 0001 : 1
    // 0010 : 2
    // 1000 : 8

    char c; // 1-byte
    int i; // normally 4 bytes (32 bit)
    long int li;
    long long int lli;

    // Floating-point types
    float f;
    double d;
    long double ld;

    // Basic arithmetic operators
    // +, -, *, /, %

    x = 3.5;

    printf("The value of x is: %i\n", x);

    return x;
}