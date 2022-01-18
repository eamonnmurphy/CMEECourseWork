#include <stdio.h>
#include <string.h>

struct site_data
{
    float latitude;
    float longitude;
    float elevation;

    int observed_spp[500];
    int condition;
};

typedef struct site_data site_data_s;


int main(void)
{
    struct site_data site1;
    struct site_data site2;
    struct site_data site3;

    struct site_data mysites[3];

    // Let's init a struct
    memset(&site1, 0, sizeof(site1));

    memset(mysites, 0, sizeof(mysites));

    site1.latitude = 74.3444;
    printf("The latitude of site 1 is: %f\n", site1.latitude);
    printf("The longitude of site 1: %f\n", site1.longitude);

    return 0;
}