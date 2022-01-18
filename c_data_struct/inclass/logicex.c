#include <stdio.h>
#include <string.h>

int main(void)
{
    int a, b, c, d;

    a = 0;

    b = 32;

    printf("Checking for !a: %i\n", !a);
    
    printf("Checking for !b: %i\n", !b);

    char message[] = "The quick brown fox";

    // char *strchr(const char *str, int c)

    char s = 'm';

    if (!strchr(message, s)) {
        printf("Character %c in the message '%s' does not exist\n", s, message);
    } else {
        printf("Character %c found in the message\n", s);
    }

    a = 0;
    b = 2;

    !a && b;
    a || !b;

    return 0;
}