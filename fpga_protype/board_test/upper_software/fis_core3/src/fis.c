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
    float weight3 = 0;

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
    

    drv_write32(0x2108, number);         
    drv_write32(0x21a0, in_data0);       
    drv_write32(0x21a4, in_data1);
    drv_write32(0x21a8, in_data2);
  
   fpgaInitAndRun(&weight3);
   
    return weight3;

}


void fpgaInitAndRun(float *weight3)
{
    unsigned int end3;
    float r0;
    int r1;
    float r2, r3, r4;
    drv_write32(0x2128,1);                 

    for (int i=0; i<10000; i++)
    {
        end3 = drv_read32(0x2148);         
        
        if(end3==1)
        {
           break;
        }
    }

    r0 = drv_read32(0x2168);
    r1 = drv_read32(0x2168);
    r2 = r0/4096;
    r3 = ~(r1-1);
    r4 = r3/4096;


    if(r2 < 1048570)
    {
      *weight3= r2;
    }
    else
    {
      *weight3= -r4;
    }
}


void DDRreset()
{
    unsigned int over,reset,end;   
    drv_write32(0x2010,0);

    drv_write32(0x2014,1);                  
    drv_write32(0x2014,0);
    

    drv_write32(0x2004,1);                
    
    drv_write32(0x2004,0);
} 


