#include <stdio.h>
#include <stdlib.h>

struct node
{
    struct node* left;
    struct node* right;
    struct node* parent;
    int          index;
    char*        name;
};
typedef struct node node;

void traverse_node(node* n)
{   
    if (n != NULL)
    {
        traverse_node(n->left);
        traverse_node(n->right);
        printf("The species name of this node is: %c\n", *n->name);
    }
}

int main(void)
{
    node n1;
    node n2;
    node n3;

    char spp1 = 'f';
    char spp2 = 'b';
    char spp3 = 'h';

    n1.name = &spp1;
    n2.name = &spp2;
    n3.name = &spp3;

    n1.parent = &n3;
    n2.parent = &n2;

    n1.left = n1.right = n2.left = n2.right = NULL;

    n3.left = &n1;
    n3.right = &n2;

    traverse_node(&n3);

    return 0;
}