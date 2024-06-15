#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "dev.h"

clock_t dev_clock()
{
    return clock();
}

void dev_sleep(unsigned int msec)
{
    usleep(msec*1000);
}

double dev_bandWidth(double nBytes, clock_t beginClock, clock_t endClock)
{
    double fCostTime = (double)(endClock-beginClock)/CLOCKS_PER_SEC;
    double fBandWidth = (double)nBytes/1024/1024/fCostTime;
    return fBandWidth;
}

unsigned long nLockAddr = 0;
unsigned int nLockLength = 0;
unsigned int *lpLockBuffer = 0;

int dev_init(off_t bar_add, char* g_szDmaSelPath)
{
    int var = 0;

    var = drv_init();

    if (var != DRV_SUCCESS)
        return var;

    var = drv_openMemManager(g_szDmaSelPath);

    if (var != DRV_SUCCESS)
        return var;

    var = drv_attach(bar_add);
    if (var != DRV_SUCCESS)
        return var;

    nLockAddr = 0;
    nLockLength = 0x20000;
    var = drv_lock(&lpLockBuffer, &nLockAddr);
    

    if (lpLockBuffer == 0)
        return DEV_MEM_NULL;

	  return DEV_SUCCESS;
}

int dev_uninit()
{
    return drv_closeMemManager();
}

int dev_getInfo(unsigned int *ptr, size_t nMax)
{
    if (ptr == 0)
        return DEV_MEM_NULL;
    
    if (nMax < 5)
        return DEV_MEM_SIZE;

    ptr[0] = drv_read32(0x00);
    ptr[1] = drv_read32(0x08);
    ptr[2] = drv_read32(0x0C);
    ptr[3] = drv_read32(0x10);
    ptr[4] = drv_read32(0x14);

    return DEV_SUCCESS;
}

int dev_host2fpga(off_t nLength, int nTimes)
{
    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    clock_t beginClock = dev_clock();

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        for (off_t offset=0; offset<nLength; offset++)
        {
            drv_write32(0x010000+offset*4, lpWriteBuffer[offset]);
        }
    }

    clock_t endClock = dev_clock();

    printf("HOST2FPGA = %.2lfMB/sec\n", dev_bandWidth((double)nLength*sizeof(unsigned int)*nTimes, beginClock, endClock));

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_fpga2host(off_t nLength, int nTimes)
{
    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    clock_t beginClock = dev_clock();

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        for (off_t offset=0; offset<nLength; offset++)
        {
            lpReadBuffer[offset] = drv_read32(0x010000+offset*4);
        }
    }

    clock_t endClock = dev_clock();

    printf("FPGA2HOST = %.2lfMB/sec\n", dev_bandWidth((double)nLength*sizeof(unsigned int)*nTimes, beginClock, endClock));

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_host_fpga(off_t nLength)
{
    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    for (off_t offset=0; offset<nLength; offset++)
    {
        drv_write32(0x010000+offset*4, lpWriteBuffer[offset]);
    }

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpReadBuffer[offset] = drv_read32(0x010000+offset*4);
    }

    off_t nErrCount = 0;
    for (off_t offset=0; offset<nLength; offset++)
    {
        if (lpWriteBuffer[offset] != lpReadBuffer[offset])
        {
            nErrCount++;
        }
    }

    printf("ERR = %lX\n", nErrCount);

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_fpga2ddr(unsigned int nAddr, unsigned int nLength, unsigned int var, unsigned int var_add)
{
    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    drv_write32(0x60, nAddr);
    drv_write32(0x64, nLength);
    drv_write32(0x68, var);
    drv_write32(0x6C, var_add);

    drv_write32(0x70, 1);

    unsigned int nFlag = 1;
    do 
    {
        nFlag = drv_read32(0x74);
        dev_sleep(100);
    } while (nFlag != 1);

    printf("FPGA2DDR = %.2lfMB/sec\n", (double)nLength*sizeof(unsigned int)*1000.0*1000.0*1000.0/10/drv_read32(0x88)/1024.0/1024.0);

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_ddr2fpga(unsigned int nAddr, unsigned int nLength)
{
    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    drv_write32(0x60, nAddr);
    drv_write32(0x64, nLength);

    drv_write32(0x78, 1);

    unsigned int nFlag = 1;
    do 
    {
        nFlag = drv_read32(0x7C);
        dev_sleep(100);
    } while (nFlag != 1);

    printf("DDR2FPGA = %.2lfMB/sec\n", (double)nLength*sizeof(unsigned int)*1000.0*1000.0*1000.0/10/drv_read32(0x8C)/1024.0/1024.0);

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_fpga_ddr(unsigned int nAddr, unsigned int nLength, unsigned int var, unsigned int var_add)
{
    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    drv_write32(0x60, nAddr);
    drv_write32(0x64, nLength);
    drv_write32(0x68, var);
    drv_write32(0x6C, var_add);

    drv_write32(0x80, 1);

    unsigned int nFlag = 1;
    do 
    {
        nFlag = drv_read32(0x84);
        dev_sleep(100);
    } while (nFlag != 1);

    printf("FPGA2DDR = %.2lfMB/sec\n", (double)nLength*sizeof(unsigned int)*1000.0*1000.0*1000.0/10/drv_read32(0x88)/1024.0/1024.0);
    printf("DDR2FPGA = %.2lfMB/sec\n", (double)nLength*sizeof(unsigned int)*1000.0*1000.0*1000.0/10/drv_read32(0x8C)/1024.0/1024.0);
    printf("ERR = %X\n", drv_read32(0x90));

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_host2ddr_dma(unsigned int nAddr, unsigned int nLength, int nTimes)
{
    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((nLength+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    memcpy(lpLockBuffer, lpWriteBuffer, nLength*sizeof(unsigned int));

    clock_t beginClock = dev_clock();

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        unsigned int tmp;
        
        tmp = nLockAddr & 0xFFFFFFFF;
        drv_write32(0x24, tmp);
        printf("reg[0x24]=%x\n", tmp);

        tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
        drv_write32(0x20, tmp);
        printf("reg[0x20]=%x\n", tmp);	

        drv_write32(0x30, nLength);
        printf("reg[0x30]=%x\n", nLength);

        unsigned long ltmp = nLockAddr+nLength*sizeof(unsigned int);
        tmp = ltmp & 0xFFFFFFFF;
        drv_write32(0x44, tmp);
        printf("reg[0x44]=%x\n", tmp);

        tmp = (ltmp >> 32) & 0xFFFFFFFF;
        drv_write32(0x40, tmp);
        printf("reg[0x40]=%x\n", tmp);

        drv_write32(0x100, 1);

        printf("waitting for 0x5E23[] ...\n");

        while (lpLockBuffer[nLength] != 0x5E23);
        
        lpLockBuffer[nLength] = 0;
    }
    
    clock_t endClock = dev_clock();

    printf("HOST2DDR@DMA = %.2lfMB/sec\n", dev_bandWidth((double)nLength*sizeof(unsigned int)*nTimes, beginClock, endClock));

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_ddr2host_dma(unsigned int nAddr, unsigned int nLength, int nTimes)
{
    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((nLength+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    clock_t beginClock = dev_clock();

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        unsigned int tmp;

	    tmp = nLockAddr & 0xFFFFFFFF;
        drv_write32(0x2C, tmp);
        printf("reg[0x2C]=%x\n", tmp);

        tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
        drv_write32(0x28, tmp);
        printf("reg[0x28]=%x\n", tmp);

        drv_write32(0x34, nLength);

        unsigned long ltmp = nLockAddr+nLength*sizeof(unsigned int);
        tmp = ltmp & 0xFFFFFFFF;
        drv_write32(0x4C, tmp);
        printf("reg[0x4C]=%x\n", tmp);

        tmp = (ltmp >> 32) & 0xFFFFFFFF;
        drv_write32(0x48, tmp);
         printf("reg[0x48]=%x\n", tmp);

        drv_write32(0x104, 1);

	    printf("waiting for 0x5E23[] ...\n");

        while (lpLockBuffer[nLength] != 0x5E23);

        lpLockBuffer[nLength] = 0;
    }
    
    clock_t endClock = dev_clock();

    printf("DDR2HOST@DMA = %.2lfMB/sec\n", dev_bandWidth((double)nLength*sizeof(unsigned int)*nTimes, beginClock, endClock));

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_host_ddr_dma(unsigned int nAddr, unsigned int nLength)
{
    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((nLength+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    memcpy(lpLockBuffer, lpWriteBuffer, nLength*sizeof(unsigned int));

    unsigned int tmp;
    unsigned long ltmp;
        
    tmp = nLockAddr & 0xFFFFFFFF;
    drv_write32(0x24, tmp);
    printf("reg[0x24]=%x\n", tmp);

    tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
    drv_write32(0x20, tmp);
    printf("reg[0x20]=%x\n", tmp);	

    drv_write32(0x30, nLength);
    printf("reg[0x30]=%x\n", nLength);

    ltmp = nLockAddr+nLength*sizeof(unsigned int);
    tmp = ltmp & 0xFFFFFFFF;
    drv_write32(0x44, tmp);
    printf("reg[0x44]=%x\n", tmp);

    tmp = (ltmp >> 32) & 0xFFFFFFFF;
    drv_write32(0x40, tmp);
    printf("reg[0x40]=%x\n", tmp);

    drv_write32(0x100, 1);

    dev_sleep(200);

    while (lpLockBuffer[nLength] != 0x5E23);
    lpLockBuffer[nLength] = 0;

    dev_sleep(1000);

    tmp = nLockAddr & 0xFFFFFFFF;
    drv_write32(0x2C, tmp);
    printf("reg[0x2C]=%x\n", tmp);

    tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
    drv_write32(0x28, tmp);
    printf("reg[0x28]=%x\n", tmp);

    drv_write32(0x34, nLength);

    ltmp = nLockAddr+nLength*sizeof(unsigned int);
    tmp = ltmp & 0xFFFFFFFF;
    drv_write32(0x4C, tmp);
    printf("reg[0x4C]=%x\n", tmp);

    tmp = (ltmp >> 32) & 0xFFFFFFFF;
    drv_write32(0x48, tmp);
    printf("reg[0x48]=%x\n", tmp);

    drv_write32(0x104, 1);

    dev_sleep(200);

    printf("waiting for 0x5E23[] ...\n");

    while (lpLockBuffer[nLength] != 0x5E23);
    lpLockBuffer[nLength] = 0;

    memcpy(lpReadBuffer, lpLockBuffer, nLength*sizeof(unsigned int));

    off_t nErrCount = 0;
    for (off_t offset=0; offset<nLength; nLength++)
    {
        if (lpWriteBuffer[offset] != lpReadBuffer[offset])
        {
            nErrCount++;
        }
    }

    printf("ERR = %lX\n", nErrCount);

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_host2fpga_dma(off_t nLength, int nTimes)
{
    printf("sizeof(int)=%d\n", sizeof(unsigned int));
    printf("nLength=%lx\n", nLength);

    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((nLength+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    memcpy(lpLockBuffer, lpWriteBuffer, nLength*sizeof(unsigned int));

    clock_t beginClock = dev_clock();

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        printf("nLockAddr=%lx\n", nLockAddr);
        
        unsigned int tmp;
        
        tmp = nLockAddr & 0xFFFFFFFF;
        drv_write32(0x24, tmp);
        printf("reg[0x24]=%x\n", tmp);

        tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
        drv_write32(0x20, tmp);
        printf("reg[0x20]=%x\n", tmp);	

        drv_write32(0x30, nLength);
        printf("reg[0x30]=%x\n", nLength);

        unsigned long ltmp = nLockAddr+nLength*sizeof(unsigned int);
        tmp = ltmp & 0xFFFFFFFF;
        drv_write32(0x44, tmp);
        printf("reg[0x44]=%x\n", tmp);

        tmp = (ltmp >> 32) & 0xFFFFFFFF;
        drv_write32(0x40, tmp);
        printf("reg[0x40]=%x\n", tmp);

        drv_write32(0x38, 1);

        printf("waitting for 0x5E23[] ...\n");

        while (lpLockBuffer[nLength] != 0x5E23);
        
        lpLockBuffer[nLength] = 0;
    }
    
    clock_t endClock = dev_clock();

    printf("HOST2FPGA@DMA = %.2lfMB/sec\n", dev_bandWidth((double)nLength*sizeof(unsigned int)*nTimes, beginClock, endClock));

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_fpga2host_dma(off_t nLength, int nTimes)
{
    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((nLength+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    clock_t beginClock = dev_clock();

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        unsigned int tmp;

	    tmp = nLockAddr & 0xFFFFFFFF;
        drv_write32(0x2C, tmp);
        printf("reg[0x2C]=%x\n", tmp);

        tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
        drv_write32(0x28, tmp);
        printf("reg[0x28]=%x\n", tmp);

        drv_write32(0x34, nLength);

        unsigned long ltmp = nLockAddr+nLength*sizeof(unsigned int);
        tmp = ltmp & 0xFFFFFFFF;
        drv_write32(0x4C, tmp);
        printf("reg[0x4C]=%x\n", tmp);

        tmp = (ltmp >> 32) & 0xFFFFFFFF;
        drv_write32(0x48, tmp);
         printf("reg[0x48]=%x\n", tmp);

        drv_write32(0x3C, 1);

	    printf("waiting for 0x5E23[] ...\n");

        while (lpLockBuffer[nLength] != 0x5E23);

        lpLockBuffer[nLength] = 0;
    }
    
    clock_t endClock = dev_clock();

    printf("FPGA2HOST@DMA = %.2lfMB/sec\n", dev_bandWidth((double)nLength*sizeof(unsigned int)*nTimes, beginClock, endClock));

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_host_fpga_dma(off_t nLength)
{
    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((nLength+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    unsigned int *lpWriteBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));
    unsigned int *lpReadBuffer = (unsigned int *)malloc(nLength*sizeof(unsigned int));

    for (off_t offset=0; offset<nLength; offset++)
    {
        lpWriteBuffer[offset] = offset;
        lpReadBuffer[offset] = 0;
    }

    memcpy(lpLockBuffer, lpWriteBuffer, nLength*sizeof(unsigned int));

    unsigned int tmp;
    unsigned long ltmp;
        
    tmp = nLockAddr & 0xFFFFFFFF;
    drv_write32(0x24, tmp);
    printf("reg[0x24]=%x\n", tmp);

    tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
    drv_write32(0x20, tmp);
    printf("reg[0x20]=%x\n", tmp);	

    drv_write32(0x30, nLength);
    printf("reg[0x30]=%x\n", nLength);

    ltmp = nLockAddr+nLength*sizeof(unsigned int);
    tmp = ltmp & 0xFFFFFFFF;
    drv_write32(0x44, tmp);
    printf("reg[0x44]=%x\n", tmp);

    tmp = (ltmp >> 32) & 0xFFFFFFFF;
    drv_write32(0x40, tmp);
    printf("reg[0x40]=%x\n", tmp);

    drv_write32(0x38, 1);

    printf("waiting for 0x5e23[2]\n");   

    while (lpLockBuffer[nLength] != 0x5E23);
    lpLockBuffer[nLength] = 0;

	dev_sleep(1000);

    tmp = nLockAddr & 0xFFFFFFFF;
    drv_write32(0x2C, tmp);
    printf("reg[0x2C]=%x\n", tmp);

    tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
    drv_write32(0x28, tmp);
    printf("reg[0x28]=%x\n", tmp);

    drv_write32(0x34, nLength);

    ltmp = nLockAddr+nLength*sizeof(unsigned int);
    tmp = ltmp & 0xFFFFFFFF;
    drv_write32(0x4C, tmp);
    printf("reg[0x4C]=%x\n", tmp);

    tmp = (ltmp >> 32) & 0xFFFFFFFF;
    drv_write32(0x48, tmp);
        printf("reg[0x48]=%x\n", tmp);

    drv_write32(0x3C, 1);
    
    printf("waiting for 0x5e23[3]\n");

    while (lpLockBuffer[nLength] != 0x5E23);
    lpLockBuffer[nLength] = 0;

    printf(":-)\n");

    memcpy(lpReadBuffer, lpLockBuffer, nLength*sizeof(unsigned int));

    off_t nErrCount = 0;
    for (off_t offset=0; offset<nLength; offset++)
    {
        if (lpWriteBuffer[offset] != lpReadBuffer[offset])
        {
            nErrCount++;
        }
    }

    printf("ERR = %lX\n", nErrCount);

    free(lpWriteBuffer);
    free(lpReadBuffer);

    return DEV_SUCCESS;
}

int dev_download(unsigned int nAddr, unsigned int nLength, unsigned int nStep, char *lpszFileName)
{
    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((1024+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    FILE *fp = fopen(lpszFileName, "rb");

    nLength=nLength/16;
    nLength=nLength*16;

    drv_write32(0x1000, nAddr);
    drv_write32(0x1004, nLength);
    drv_write32(0x1008, nStep);
    drv_write32(0x100C, 1);

    unsigned int tmp;
    unsigned long ltmp;
        
    tmp = nLockAddr & 0xFFFFFFFF;
    drv_write32(0x1014, tmp);
    //printf("reg[0x1014]=%x\n", tmp);

    tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
    drv_write32(0x1010, tmp);
    //printf("reg[0x1010]=%x\n", tmp);	

    drv_write32(0x1018, 1024);

    ltmp = nLockAddr+1024*sizeof(unsigned int);
    tmp = ltmp & 0xFFFFFFFF;
    drv_write32(0x1020, tmp);
    //printf("reg[0x1020]=%x\n", tmp);

    tmp = (ltmp >> 32) & 0xFFFFFFFF;
    drv_write32(0x101C, tmp);
    //printf("reg[0x101C]=%x\n", tmp);	

    int nTimes = nLength/1024;
    int nLast = nLength%1024;

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        fread(lpLockBuffer, 4096, 1, fp);

				drv_write32(0x1024, 1);

        while (lpLockBuffer[1024] != 0x5E23);
					lpLockBuffer[1024] = 0;
    }

    if (nLast)
    {
        drv_write32(0x1018, nLast);

        fread(lpLockBuffer, nLast*4, 1, fp);

        drv_write32(0x1024, 1);

        while (lpLockBuffer[1024] != 0x5E23);
		lpLockBuffer[1024] = 0;
    }

    fclose(fp);

    return DEV_SUCCESS;
}

int dev_upload(unsigned int nAddr, unsigned int nLength, unsigned int nStep, const char *lpszFileName)
{
    if ((nLockAddr == 0) || (lpLockBuffer == 0))
        return DEV_MEM_NULL;

    if ((1024+16)*sizeof(unsigned int) >= nLockLength)
        return  DEV_MEM_SIZE;

    FILE *fp = fopen(lpszFileName, "wb");

    nLength=nLength/16;
    nLength=nLength*16;

    drv_write32(0x1060, nAddr);
    drv_write32(0x1064, nLength);
    drv_write32(0x1068, nStep);
    drv_write32(0x106C, 1);

    unsigned int tmp;
    unsigned long ltmp;
        
    tmp = nLockAddr & 0xFFFFFFFF;
    drv_write32(0x1074, tmp);
    printf("reg[0x1074]=%x\n", tmp);

    tmp = (nLockAddr >> 32) & 0xFFFFFFFF;
    drv_write32(0x1070, tmp);
    printf("reg[0x1070]=%x\n", tmp);

    drv_write32(0x1078, 1024);


    ltmp = nLockAddr+1024*sizeof(unsigned int);
    tmp = ltmp & 0xFFFFFFFF;
    drv_write32(0x1080, tmp);
    printf("reg[0x1080]=%x\n", tmp);

    tmp = (ltmp >> 32) & 0xFFFFFFFF;
    drv_write32(0x107C, tmp);
    printf("reg[0x107C]=%x\n", tmp);	

    int nTimes = nLength/1024;
    int nLast = nLength%1024;

    for (int nTime=0; nTime<nTimes; nTime++)
    {
        drv_write32(0x1084, 1);

        while (lpLockBuffer[1024] != 0x5E23);
					lpLockBuffer[1024] = 0;

        fwrite(lpLockBuffer, 4096, 1, fp);
    }

    if (nLast)
    {
        drv_write32(0x1078, nLast);

        drv_write32(0x1084, 1);

        while (lpLockBuffer[1024] != 0x5E23);
						lpLockBuffer[1024] = 0;

        fwrite(lpLockBuffer, nLast*4, 1, fp);
    }

    fclose(fp);

    return DEV_SUCCESS;
}

double dev_getPower()
{
    DWORD value_power[2];
    value_power[0] = drv_read32(0x180);
    value_power[1] = drv_read32(0x184); 
    return (((double)(value_power[0]*40.0/10000.0))*((double)(value_power[1]*8.0/1000.0)));
}
