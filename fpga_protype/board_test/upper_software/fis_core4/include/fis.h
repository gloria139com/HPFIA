#ifndef __FIS_H__
#define __FIS_H__

#define INPUT_DIM  3
#define BAR_ADDR   0x80060c00000
void fis_init();
float fis(float *input_data_i, short number);
void fpgaInitAndRun(float *weight);
void DDRreset();

#endif
