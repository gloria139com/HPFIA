#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <time.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include "drv.h"
#include "errno.h"

int versionID = 0;

int drv_getVersionID()
{
    return versionID;
}

int drvEnabled = 0;

int drv_init()
{

    #ifdef __x86_64__
        printf("__x86_64__\n");
    #elif __i386__
        printf("__i386__\n");
    #endif

    drvEnabled = 1;

    return DRV_SUCCESS;
}


int memManager = (-1);
int mmapFd = (-1);

unsigned char *vir_addr = 0;
long  phy_addr = 0;

int drv_openMemManager(char* g_szDmaSelPath)
{
    if (drvEnabled == 0)
        return DRV_PRIVILEGE;

    memManager = open("/dev/mem", O_RDWR|O_SYNC);

    if (memManager == (-1))
        return DRV_IO;

    mmapFd = open(g_szDmaSelPath, O_RDWR|O_SYNC);
    if(mmapFd < 0)
        return DRV_IO;

    long tmp;
    unsigned long args;
    
    ioctl(mmapFd, 1,(unsigned long) &args);
    
    phy_addr =args;
   
    vir_addr = (unsigned char *)mmap(0, 0x20000, PROT_READ|PROT_WRITE, MAP_SHARED, mmapFd, phy_addr);
    
    if (vir_addr == (-1))
        return DRV_MEM;

    return DRV_SUCCESS;
}

int drv_closeMemManager()
{
    close(mmapFd);
    close(memManager);

    return DRV_SUCCESS;
}


unsigned char *ptrBar = 0;

int drv_attach(off_t offset)
{
    if (drvEnabled == 0)
        return DRV_PRIVILEGE;

    ptrBar = (unsigned char *)mmap(NULL, 0x400000, PROT_READ|PROT_WRITE, MAP_SHARED, memManager, offset);

    if (ptrBar == 0)
        return DRV_MEM;

    return DRV_SUCCESS;
}

unsigned int drv_read32(off_t offset)
{
	unsigned int tmp = *((unsigned int *)(ptrBar+offset));
	
	return tmp;
    return *((unsigned int *)(ptrBar+offset));
}

void drv_write32(off_t offset, unsigned int var)
{

	
	*((unsigned int *)(ptrBar+offset)) = var;
}

int drv_lock(unsigned int **pvaddr, unsigned long *ppaddr)
{
    if (drvEnabled == 0)
        return 0;

    *pvaddr = (unsigned int *)vir_addr;
    *ppaddr = phy_addr;

    return DRV_SUCCESS;
}
