#include "fft.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <png.h>
int BCREStartAudioStream(int afx, FILE** f, float** spectra, char* audioFile) {
	if (afx == 1) return 1;
	*f = fopen(audioFile, "r");
	*spectra = (float*)malloc(1024*sizeof(float));
	if (*f == NULL) {
		printf("FILE OPEN FAILURE\n");
		return 0;
	}
	if (passHeader(*f) == 0) {
		printf("No song input!\n");
		return 0;
	}
	return 1;
}

int BCRESeekAudio(int afx, int* audioFrames, int totalFrames, FILE* f, float* spectra) {
	if (afx == 1) return 1;
	*audioFrames = seek(totalFrames, *audioFrames, f, spectra);
	if (*audioFrames == -1) {
		printf("END OF AUDIO STREAM\n");
		return 0;
	}
	return 1;
}
int save_png_file(char* data, char* path, int width, int height) {
	FILE* f;
	png_structp pngData = NULL;
	png_infop info = NULL;
	png_byte** rowPointers = NULL;
	int pixelSize = 3;
	int depth = 8;
	f = fopen(path, "wb");
	if (!f) {
		printf("Failed to open pngfile!\n");
		return -1;
	}
	pngData = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

	info = png_create_info_struct(pngData);

	png_set_IHDR(pngData, info, width, height, depth, PNG_COLOR_TYPE_RGB, PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);
	rowPointers = png_malloc(pngData, height * sizeof(png_byte*));
	for (int i=0; i<height; i++) {
		png_byte* row = png_malloc(pngData, sizeof(char) * width * pixelSize);
		rowPointers[i] = row;
		for (int j=0; j<width*pixelSize; j+=3) {
			char red = data[width*pixelSize*(height-i-1) + j];
			char green = data[width*pixelSize*(height-i-1) + j+1];
			char blue = data[width*pixelSize*(height-i-1) + j+2];
			row[j] = red;
			row[j+1] = green;
			row[j+2] = blue;
		}
	}
	png_init_io(pngData, f);
	png_set_rows(pngData, info, rowPointers);
	png_write_png(pngData, info, PNG_TRANSFORM_IDENTITY, NULL);
	for (int i=0; i<height; i++) {
		png_free(pngData, rowPointers[i]);
	}
	png_free(pngData, rowPointers);
	fclose(f);
	return 0;
}

int BCRERenderCurrentFrame(int r, int width, int height, int totalFrames, char* pixelData) {
	if (r == 1) return 1;
	char name[1024] = "";
	strcat(name, "bin/");

	if (totalFrames < 10000) strcat(name, "0");
	if (totalFrames < 1000) strcat(name, "0");
	if (totalFrames < 100) strcat(name, "0");
	if (totalFrames < 10) strcat(name, "0");
	char temp[8];
	sprintf(temp, "%d", totalFrames);
	strcat(name, temp);
	strcat(name, "-out.png");
	glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_BYTE, pixelData); 
	save_png_file(pixelData, name, width, height);
	return 1;
}
