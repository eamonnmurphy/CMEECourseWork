#include <stdio.h>

const int arraymax = 5;

int main(void)
{
    int x;
    int x_1[1];
    int myarray1[5]; // Explicit definition/sizing of array
    int myarray2[7] = {7,9,21,55,199191,4,18};

    arraymax = 10;

    myarray1[0] = 0;
    myarray1[1] = 0;
    myarray1[2] = 0;

    x = myarray1[2];

    for (x = 0; x < 5; ++x)
    {
        myarray1[x] = 1;
    }
    
    x = myarray1[5]; 

    printf("From outside array: %i\n", x);

    return 0;
}