#ifndef _DRV_H
#define _DRV_H

#define DRV_SUCCESS     0
#define DRV_PRIVILEGE   1
#define DRV_IO          2
#define DRV_MEM         3

int drv_getVersionID();

int drv_init();

int drv_openMemManager(char* g_szDmaSelPath);

int drv_attach(off_t offset);

int drv_lock(unsigned int **pvaddr, unsigned long *ppaddr);

unsigned int drv_read32(off_t offset);

void drv_write32(off_t offset, unsigned int var);

int drv_closeMemManager();

#endif
