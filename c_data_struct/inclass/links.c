#include <stdio.h>

struct ilink
{
    int data;
    struct ilink *next;
    struct ilink *back; // Optional for a doubly-linked list.
};
typedef struct ilink ilink; // Gives me an alias so I don't need to write "struct"

void traverse_list(ilink *p)
{
    if (p != NULL)
    {
        printf("%i\n", p->data);
        traverse_list(p->next);
        printf("%i\n", p->data);
    }
}

int main(void)
{
    ilink i1;
    ilink i2;
    ilink i3;

    i1.data = 47;
    i2.data = 23;
    i3.data = 9;

    i1.next = &i2;
    i2.next = &i3;
    i3.next = NULL;

    i1.back = NULL;
    i2.back = &i1;
    i3.back = &i2;

    // i1.next = &i3; // Eliminates i2 from linked list
    // OR
    i1.next = i1.next->next; // Points to next in the element which i1.next points to

    traverse_list(&i1);

    return 0;
}