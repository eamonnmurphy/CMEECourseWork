#include <stdio.h>
#include <string.h>

int main(void)
{
    char s1[] = "The quick brown fox ";
    char s2[] = "jumped over the lazy dog\n";

    char s3[100];

    strcat(s3, s1);
    strcat(s3, s2);

    printf("%s", s3);

    return 0; 
}