#ifndef _DEV_H
#define _DEV_H

#include "drv.h"

#define DEV_SUCCESS     DRV_SUCCESS
#define DEV_PRIVILEGE   DRV_PRIVILEGE
#define DEV_IO          DRV_IO
#define DEV_MEM_NULL    (DRV_MEM+0)
#define DEV_MEM_SIZE    (DRV_MEM+1)

typedef unsigned long       DWORD;

clock_t dev_clock();
void dev_sleep(unsigned int msec);
double dev_bandWidth(double nBytes, clock_t beginClock, clock_t endClock);

int dev_init(off_t bar_add, char* g_szDmaSelPath);
int dev_uninit();

int dev_getInfo(unsigned int *ptr, size_t nMax);

int dev_host2fpga(off_t nLength, int nTimes);
int dev_fpga2host(off_t nLength, int nTimes);
int dev_host_fpga(off_t nLength);

int dev_fpga2ddr(unsigned int nAddr, unsigned int nLength, unsigned int var, unsigned int var_add);
int dev_ddr2fpga(unsigned int nAddr, unsigned int nLength);
int dev_fpga_ddr(unsigned int nAddr, unsigned int nLength, unsigned int var, unsigned int var_add);

int dev_host2fpga_dma(off_t nLength, int nTimes);
int dev_fpga2host_dma(off_t nLength, int nTimes);
int dev_host_fpga_dma(off_t nLength);

int dev_host2ddr_dma(unsigned int nAddr, unsigned int nLength, int nTimes);
int dev_ddr2host_dma(unsigned int nAddr, unsigned int nLength, int nTimes);
int dev_host_ddr_dma(unsigned int nAddr, unsigned int nLength);

int dev_download(unsigned int nAddr, unsigned int nLength, unsigned int nStep, char *lpszFileName);
int dev_upload(unsigned int nAddr, unsigned int nLength, unsigned int nStep, const char *lpszFileName);

double dev_getPower();
#endif
