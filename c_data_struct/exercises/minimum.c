#include <stdio.h>

int find_minimum(int array[], int length)
{
    int min = array[0];

    printf("%i\n", length);

    for (size_t i = 0; i < length; i++)
    {
        if (array[i] < min)
        {
            min = array[i];
        }
    }

    return min;
}

int main(void)
{
    int array_example[] = {123, 747, 768, 2742, 988, 1121, 109, 999, 727, 1030, 999, 2014, 1402};
    int array_len = 13;

    int min = find_minimum(array_example, array_len);

    printf("The minimum value in the array is %i\n", min);

    return 0;
}