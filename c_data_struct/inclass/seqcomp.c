#include <stdio.h>
#include <string.h>

int base_to_bits(char c)
{
    if (c == 'A')
    {
        return 1;
    }
    if (c == 'C')
    {
        return 1 << 1;
    }
    if (c == 'G')
    {
        return 1 << 2;
    }
    if (c == 'T')
    {
        return 1 << 3;
    }
    if (c == '?') {
        return ~0;
    }

    printf("Value %c is not a DNA base\n", c);

    return 0;
}

int main(void)
{
    char sp1_seq1[] = "ACCCGT";
    char sp1_seq2[] = "ACCCCT";
    char sp2_seq1[] = "ATTGCT";
    char sp3_seq1[] = "ACGCTT";

    // Want to get the (uncorrected) genetic distance between each species
    // Could loop over all pairwise comparisions:
    int seqlen = strlen(sp1_seq1);
    int dist_spp12;
    int i;

    for (i = 0; i < seqlen; ++i)
    {
        if (sp1_seq1[i] != sp2_seq1[i])
        {
            ++dist_spp12;
        }
    }
    
    int sp1_seq[seqlen];
    int sp2_seq[seqlen];
    int sp3_seq[seqlen];

    memset(sp1_seq, 0, seqlen * sizeof(int));
    memset(sp2_seq, 0, seqlen * sizeof(int));
    memset(sp3_seq, 0, seqlen * sizeof(int));

    // Convert sp1
    for (i = 0; i < seqlen; ++i)
    {
        sp1_seq[i] = base_to_bits(sp1_seq1[i]);
        sp1_seq[i] |= base_to_bits(sp1_seq2[i]); // a |= x is the same as a = a | x (bitwise);
    }

    // Convert sp2
    for (i = 0; i < seqlen; ++i)
    {
        sp2_seq[i] = base_to_bits(sp2_seq1[i]);
    }

    // Convert sp3
    for (i = 0; i < seqlen; ++i)
    {
        sp3_seq[i] = base_to_bits(sp3_seq1[i]);
    }

    // Do all pairwise comparisons
    // sp1 vs sp2
    int dist1_2 = 0;
    for (i = 0; i < seqlen; ++i)
    {
        if (!(sp1_seq[i] & sp2_seq[i]))
        {
            ++dist1_2;
        }
    }

    // sp2 vs sp3
    int dist2_3 = 0;
    for (i = 0; i < seqlen; ++i)
    {
        if (!(sp2_seq[i] & sp3_seq[i]))
        {
            ++dist2_3;
        }
    }

    // sp1 vs sp3
    int dist1_3 = 0;
    for (i = 0; i < seqlen; ++i)
    {
        if (!(sp1_seq[i] & sp3_seq[i]))
        {
            ++dist1_3;
        }
    }

    // Print out results
    printf("Distance 1 vs 2: %i\nDistance 1 vs 3: %i\nDistance 2 vs 3: %i\n",
        dist1_2, dist1_3, dist2_3);

    return 0;
}