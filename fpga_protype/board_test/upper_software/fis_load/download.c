#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "drv.h"
#include "dev.h"


int main()
{
    short var = 0;
    off_t bar_add = 0;
    unsigned int vars[5];
    bar_add = 0x80060c00000;
    char* g_szDmaSelPath;
    g_szDmaSelPath = "/dev/memDriver0";
    var = dev_init(bar_add, g_szDmaSelPath);
    printf("dev.init = %d\n", var);
    var = dev_getInfo(vars, 5);

    var = dev_download(0x0,      1000, 8, "../branch/datasets/ds2D_01.dat");                  
    var = dev_download(0x20000,  1000, 8, "../branch/datasets/ds2D_02.dat");              
    var = dev_download(0x40000,  1000, 8, "../branch/datasets/ds2D_03.dat");              
    var = dev_download(0x60000,  1000, 8, "../branch/datasets/ds2D_04.dat");              
    var = dev_download(0x80000,  1000, 8, "../branch/datasets/ds2D_05.dat");              
    var = dev_download(0xa0000,  1000, 8, "../branch/datasets/ds2D_06.dat");                     
    var = dev_download(0xc0000,  1000, 8, "../branch/datasets/ds2D_07.dat");                     
    var = dev_download(0xe0000,  1000, 8, "../branch/datasets/ds2D_08.dat");               
    var = dev_download(0x100000, 1000, 8, "../branch/datasets/ds2D_09.dat");                
    var = dev_download(0x120000, 1000, 8, "../branch/datasets/ds2D_10.dat");   
    var = dev_download(0x140000, 1000, 8, "../branch/datasets/ds2D_11.dat");                    
    var = dev_download(0x160000, 1000, 8, "../branch/datasets/ds2D_12.dat");              
    var = dev_download(0x180000, 1000, 8, "../branch/datasets/ds2D_13.dat");                    
    var = dev_download(0x1a0000, 1000, 8, "../branch/datasets/ds2D_14.dat");   
    var = dev_download(0x1c0000, 1000, 8, "../branch/datasets/ds2D_15.dat");                    
    var = dev_download(0x1e0000, 1000, 8, "../branch/datasets/ds2D_16.dat");              
    var = dev_download(0x200000, 1000, 8, "../branch/datasets/ds2D_17.dat");       
    var = dev_download(0x220000, 1000, 8, "../branch/datasets/ds2D_18.dat");        
    var = dev_download(0x240000, 1000, 8, "../branch/datasets/ds3D_01.dat");                    
    var = dev_download(0x260000, 1000, 8, "../branch/datasets/ds3D_02.dat");                  
    var = dev_download(0x280000, 1000, 8, "../branch/datasets/ds3D_03.dat");                      
    var = dev_download(0x2a0000, 1000, 8, "../branch/datasets/ds3D_04.dat");                         
    var = dev_download(0x2c0000, 1000, 8, "../branch/datasets/ds3D_05.dat");                          
    var = dev_download(0x2e0000, 1000, 8, "../branch/datasets/ds3D_06.dat");                 
    var = dev_download(0x300000, 1000, 8, "../branch/datasets/ds3D_07.dat");             
    var = dev_download(0x320000, 1000, 8, "../branch/datasets/ds3D_08.dat");               
    var = dev_download(0x340000, 1000, 8, "../branch/datasets/ds3D_09.dat");         
    var = dev_download(0x360000, 1000, 8, "../branch/datasets/ds3D_10.dat");                   
    printf("dev_download = %d\n", var);


}
