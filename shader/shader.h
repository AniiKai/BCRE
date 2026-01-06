#ifndef SHADER_H
#define SHADER_H
#include <cglm/cglm.h>
#include <glad/glad.h>
int createShader(char* sc);

int createTexShader();

void setRes(unsigned int ID, char* name, float xy[2]);

void setSampler(unsigned int ID, char* name, int texNum);

void checkCompileErrors(GLuint shader, char* type);

void setPos(unsigned int ID, char* name, float xyz[3]);

void setTime(unsigned int ID,  char* name, float t);
void useShader(unsigned int ID);

void setSpectrum(unsigned int ID, char* name, float* data);

#endif
