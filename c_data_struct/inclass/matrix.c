// A program that illustrates the creation of
// a dynamic C matrix

#include <stdio.h>
#include <stdlib.h>

typedef struct int_matrix // I can wrap a typedef around a struct definition
{
    int nrows;
    int ncols;
    int** data;
} int_matrix;

void initialise_matrix(int nrows, int ncols, int_matrix *m)
{
    int i;
    
    (*m).nrows = nrows;
    (*m).ncols = ncols;
    (*m).data = calloc(nrows, sizeof(int*));

    for (i = 0; i < nrows; ++i)
    {
        (*m).data[i] = calloc(ncols, sizeof(int));
    }
}

int_matrix* new_int_matrix(int nrows, int ncols)
{
    int_matrix* mptr;

    mptr = calloc(1, sizeof(int_matrix));
    if (mptr != NULL)
    {
        initialise_matrix(nrows, ncols, mptr);
    }
}

void dealloc_matrix(int_matrix* m)
{
    int i;

    for (i = 0; i < (*m).nrows; ++i)
    {
        free((*m).data[i]);
    }
    free((*m).data);
}

void delete_matrix(int_matrix* m)
{
    dealloc_matrix(m);
    free(m);
}

void set_element(int data, int row, int col, int_matrix *m)
{
    if (row < (*m).nrows)
    {
        if (col < (*m).ncols)
        {
            (*m).data[row][col] = data;
        }
    }
}

// Write the equivalent function to get an element from desired coordinates
int get_element(int row, int col, int_matrix *m)
{
    if (row < (*m).nrows)
    {
        if (col < (*m).ncols)
        {
            return m->data[row][col];
        }
    }

    exit(EXIT_FAILURE);
}