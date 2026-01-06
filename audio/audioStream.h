#ifndef AUDIOSTREAM_H
#define AUDIOSTREAM_H
int BCREStartAudioStream(int afx, FILE** f, float** spectra, char* audioFilj);
int BCRESeekAudio(int afx, int* audioFrames, int totalFrames, FILE* f, float* spectra);
int BCRERenderCurrentFrame(int r, int width, int height, int totalFrames, char* pixelData);
int save_png_file(char* data, char* path, int width, int height);
#endif
