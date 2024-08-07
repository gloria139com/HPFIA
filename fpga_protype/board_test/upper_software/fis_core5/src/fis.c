#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "fis.h"
#include "drv.h"
#include "dev.h"
#include <time.h>
#include <sys/time.h>

void fis_init()
{
    off_t bar_add = 0;
    char* g_szDmaSelPath;
    g_szDmaSelPath = "/dev/memDriver0";
    bar_add = BAR_ADDR;
    dev_init(bar_add, g_szDmaSelPath);
}


float fis(float *input_data_i, short number)
{
    short var = 0;                       
    float input_data[INPUT_DIM] = {0};
    float weight5 = 0;

    for (short idx = 0; idx < INPUT_DIM; idx++)
    { 
        input_data[idx] = input_data_i[idx];         
    }
    int in_data0;
    input_data[0] = input_data[0]*4096;
    in_data0 = (int)input_data[0];
    
    int in_data1;
    input_data[1] = input_data[1]*4096;
    in_data1 = (int)input_data[1];
    
    int in_data2;
    input_data[2] = input_data[2]*4096;
    in_data2 = (int)input_data[2];
    

    drv_write32(0x2110, number);         
    drv_write32(0x21c0, in_data0);         
    drv_write32(0x21c4, in_data1);
    drv_write32(0x21c8, in_data2);

   fpgaInitAndRun(&weight5);
   
    return weight5;

}


void fpgaInitAndRun(float *weight5)
{
    unsigned int end5;
    float r0;
    int r1;
    float r2, r3, r4;
    drv_write32(0x2130,1);                 

    for (int i=0; i<10000; i++)
    {
        end5 = drv_read32(0x2150);          
        if(end5==1)
        {
           break;
        }
        
    }


    r0 = drv_read32(0x2170);
    r1 = drv_read32(0x2170);
    r2 = r0/4096;
    r3 = ~(r1-1);
    r4 = r3/4096;

    if(r2 < 1048570)
    {
      *weight5= r2;
    }
    else
    {
      *weight5= -r4;
    }

}


void DDRreset()
{
    unsigned int over,reset,end;   
    drv_write32(0x2010,0);
    
    drv_write32(0x2014,1);                  
    drv_write32(0x2014,0);
    

    drv_write32(0x2004,1);                  //FIS 复位
    drv_write32(0x2004,0);
} 


