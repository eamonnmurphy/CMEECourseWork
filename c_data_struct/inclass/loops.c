#include <stdio.h>

int main(void)
{
    int x;

    // While loop...
    while (x < 10) {
        x += 1; // equivalent to: x = x + 1;
        x++; // ++x; both are slightly different
        printf("%i\n", x);
    }

    // Do-while...
    x = 0;
    do {
        ++x;
    } while (x < 10);

    // For...
    int j;
    for ( x = 0, j = 0; x < 10; ++x) {

    }
    
    // Goto: ...
}