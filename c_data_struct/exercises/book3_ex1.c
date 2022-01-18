#include <stdio.h>

int main (void)
{
    float		a = 3;
	float	b = 2;
	int		c = 0;
	float	d = 0.0;

	c = a / b;
	d = a / b;

	printf("The result of a / b stored in c: %i\n", c);
	printf("The result of a / b stored in d: %f\n", d);

    int x = 0;
    int y = 0;

    x++;
    ++y;
    int z = x++;
    int w = ++y;

    printf("x and y are %i and %i respectively\n", x, y);
    printf("z and w are %i and %i respectively\n", z, w);

    int * ptr;
    int var = 5;
    ptr = &var;

    printf("Pointer refers to %i\n", *ptr);

	return 0;
}