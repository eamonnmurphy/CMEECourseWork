#include <stdio.h>

int main(void)
{
    int i = 0;
    int count;

    for (count = 256; i < count; i++)
    {
        int x = i;
        char c = i;

        printf("The character no. %i is %c\n", x, c);
    }
    
    return 0;
}