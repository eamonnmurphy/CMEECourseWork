#include <stdio.h>
#include <stdlib.h>

int* create_int_array(int nelems)
{
    int* newarray;

    // Declaration of malloc: void* mallco(size_t n);
    newarray = malloc(sizeof(int) * nelems);
    // newarray = calloc(nelems, sizeof(int)); // safer
    
    return newarray;
}

int main(int argc, char *argv[])
{
    int i;
    unsigned int nelems;

    // Expect one user arg, an int
    if (argc != 2)
    {
        printf("ERROR: program requires only 1 arg! (an int!)\n");
        return 1;
    }
    
    nelems = atoi(argv[1]);
    if (nelems == 0)
    {
        printf("ERROR: input must be non-zero\n");
        return 1;
    }

    int* myintegers;
    myintegers = create_int_array(nelems);

    free(myintegers);

    printf("myintegers: %i\n", *myintegers);

    return 0;

}