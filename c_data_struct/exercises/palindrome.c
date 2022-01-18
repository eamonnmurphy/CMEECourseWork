#include <stdio.h>

const char* reverse(char string[], int length, char new_string[])
{
    int i;

    for (i = 0; i < length; i++)
    {
        new_string[i] = string[length - 1 - i];
    }

    return new_string;
}

int main(void)
{
    char string[] = "palindrome";
    int len = 10;
    char new_string[len];

    reverse(string, len, new_string);

    printf("%s\n", new_string);

    return 0;
}