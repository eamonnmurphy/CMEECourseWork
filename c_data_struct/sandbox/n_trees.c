#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// unsigned long long factorial(unsigned long long n)
// {
//     if (!n) {
//         return 1;
//     }

//     return n * factorial(n-1);
// }

unsigned long long factorial(unsigned long long N)
{
 unsigned long long RESULT=1,I;
    for(I=N;I>0;I--)
    RESULT=RESULT*I;
 return(RESULT);
}

unsigned long long trees(int n)
{
    double power = pow(2, n-2);
    unsigned long long poss = factorial(2*n - 3) / (power * factorial(n-2));

    return poss;
}

int main(int argc, char * argv[])
{
    int nodes = atoi(argv[1]);

    unsigned long long res = trees(nodes);

    printf("The result of possible trees for %i nodes is %Lu\n", nodes, res);
    
    return 0;
}