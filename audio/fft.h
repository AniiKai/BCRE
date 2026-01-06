#ifndef FFT_H
#define FFT_H
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
float* fftr2(int k, int N, float* samples, float* dfdr);

unsigned int passHeader(FILE* f);

int seek(int gameFrameCount, int songFrameCount, FILE* f, float* spectra);   

#endif
