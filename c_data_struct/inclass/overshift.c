#include <stdio.h>

int main(void)
{
    signed char schar;
    unsigned char uchar;

    signed char sres;
    unsigned char ures;

    schar = 255;
    uchar = 255;

    printf("%i\n", schar);
    printf("%u\n", uchar);

    sres = schar << ((char)8);
    ures = schar << ((char)8);

    printf("%i\n", sres);
    printf("%u\n", ures);

    sres = schar >> ((char)8);
    sres = uchar >> ((char)8);

    printf("%i\n", sres);
    printf("%u\n", ures);

    return 0;
}