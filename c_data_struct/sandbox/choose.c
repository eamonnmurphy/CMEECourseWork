#include <stdio.h>
#include <stdlib.h>

int factorial(int n)
{
    if (!n) {
        return 1;
    }

    return n * factorial(n-1);
}

int choose(int n, int r)
{
    int nf = factorial(n);
    int rf = factorial(r);
    int n_rf = factorial(n-r);

    int c = nf / (rf * n_rf);

    return c;
}

int main(int argc, char * argv[])
{
    int n = atoi(argv[1]);
    int r = atoi(argv[2]);

    int res = choose(n, r);

    printf("The result of %i choose %i is %i\n", n, r, res);
    
    return 0;
}