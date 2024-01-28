#ifndef SHADER_H
#define SHADER_H
#include <cglm/cglm.h>
#include <glad/glad.h>
int createShader(char* sc);

void setRes(unsigned int ID, char* name, float xy[2]);

void checkCompileErrors(GLuint shader, char* type);

void setPos(unsigned int ID, char* name, float xyz[3]);

void setTime(unsigned int ID,  char* name, float t);
void useShader(unsigned int ID);

#endif
