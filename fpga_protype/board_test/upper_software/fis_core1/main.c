#include <stdio.h>
#include "fis.h"
#include <time.h>


int main()
{
    clock_t start, finish;
    double total_time;
    float input_data_i[3] = {60, 30, 10};
    short number = 0;
    float output_value = 0;
    fis_init();
    int i;
    int j;
    for (j=0;j<250000;j++)
    {
    for (i=18;i<19;i++){
         number=i;
    start = clock();
    output_value = fis(input_data_i, number);
    finish = clock();
    }
    }
    printf("output_value1 = %f\n\n", output_value);
    return 0;
}
