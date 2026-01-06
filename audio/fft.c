#include "fft.h"

void fftrad2(int k, int N, float* samples, float* re, float* im, int offset, int step, int altOff) { // FFT RADIX 2
	if (N == 1) {
		re[altOff] = samples[offset];
		im[altOff] = samples[offset];
		return;
	}
	fftrad2(k, N/2, samples, re, im, offset, step*2, altOff);
	fftrad2(k, N/2, samples, re, im, offset+step, step*2, altOff + N/2);
	for (int i=0; i<N/2; i++) {
		float rei = re[i+altOff];
		float imi = im[i+altOff];
		float reo = re[i+N/2+altOff];
		float imo = im[i+N/2+altOff];
		double theta = -2*M_PI*(double)i/(double)N;
		
		re[i+altOff] = rei + cos(theta)*reo - sin(theta)*imo;
		im[i+altOff] = imi + sin(theta)*reo + cos(theta)*imo;
		re[i+N/2+altOff] = rei - cos(theta)*reo + sin(theta)*imo;
		im[i+N/2+altOff] = imi - sin(theta)*reo - cos(theta)*imo;	
	}
	return;

}

float* fftr2(int k, int N, float* samples, float* dfdr) { // WRAPPER FUNCTION + IMAGINARY > REAL CONVERSION (2-norm)
	float* re = (float*)calloc(N, sizeof(float));
	float* im = (float*)calloc(N, sizeof(float));
	fftrad2(k, N, samples, re, im, 0, 1, 0);
	for (int i=0; i<k; i++) {
		dfdr[i] = sqrt(fabs(im[i]*im[i]*-1 + re[i]*re[i]));
	}
	free(re);
	free(im);
	return dfdr;
}

unsigned int passHeader(FILE* f) { // ONLY WORKS FOR WAV FILES
	unsigned int dSize = 0;
	int blk[4];
	int lc = -1000;
	int c;
	while ((c = fgetc(f)) != EOF) {
		blk[0] = blk[1]; blk[1] = blk[2]; blk[2] = blk[3]; blk[3] = c;
		lc--;
		if (lc == 0) {
			dSize = (int)blk[0] | ((int)blk[1] << 8) | ((int)blk[2] << 16) | ((int)blk[3] << 24); 
			break;
		}
		if (blk[0] == 'd' && blk[1] == 'a' && blk[2] == 't' && blk[3] == 'a') {
			lc = 4;
		}
	}
	return dSize;
}

int seek(int gameFrameCount, int songFrameCount, FILE* f, float* spectra) {
	if ((float)gameFrameCount/30 < (float)songFrameCount / 44100) return songFrameCount;

	int sampleRate = 44100;
	int numSamples = 2048;
	int k = numSamples/2;
	short int blk[2];
	float* samples = (float*)malloc(numSamples*sizeof(float));
	int c;

	int sampleCount = 0;
	int blcount = 1;
	bool left = true;

	while((c = fgetc(f)) != EOF) {
		blk[0] = blk[1]; blk[1] = c;
		if (blcount%2 == 0) {
			float data = (float)((short int)(blk[0] | (blk[1] << 8)));
			data /= 32768.0;

			float window = sin(M_PI*sampleCount/numSamples)*sin(M_PI*sampleCount/numSamples);
			if (left) {
				samples[sampleCount] = data * window;	
			} else {
				samples[sampleCount] = data * window;	
				sampleCount++;
			}
			left = !left;
		}
		if (sampleCount == numSamples) {
			spectra = fftr2(k, numSamples, samples, spectra);
			break;
		}
		blcount++;
	}
	songFrameCount += 2048;
	free(samples);
	if (c == EOF) return -1;
	return songFrameCount;	
}
