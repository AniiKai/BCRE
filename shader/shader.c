#include "shader.h"
#include <glad/glad.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int createShader(char* sc, char* lc) {
	FILE* vFile;
	FILE* fFile;
	FILE* includes[4];
	int size = 4;
	includes[0] = fopen("shader/scene-helpers.glsl", "r");
	includes[1] = fopen(sc, "r");
	includes[2] = fopen("shader/light-helpers.glsl", "r");
	includes[3] = fopen(lc, "r");
	vFile = fopen("shader/shader.vert", "r");
	fFile = fopen("shader/shader.frag", "r");
	char* vShader = (char*)calloc(65536, sizeof(char));
	char* fShader = (char*)calloc(65536, sizeof(char));
	char line[1024];
	while(fgets(line, sizeof(line), vFile) != NULL) {
		strcat(vShader, line);
	}
	for (int i=0; i<size; i++) {
		while(fgets(line, sizeof(line), includes[i]) != NULL) {
			strcat(fShader, line);
		}
	}
	while(fgets(line, sizeof(line), fFile) != NULL) {
		strcat(fShader, line);
	}
	fclose(vFile);
	fclose(fFile);
	for (int i=0; i<size; i++) {
		fclose(includes[i]);
	}

	unsigned int vertex; unsigned int fragment;
	
	vertex = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vertex, 1, (const char**)&vShader, NULL);
	glCompileShader(vertex);
	checkCompileErrors(vertex, "VERTEX");

	fragment = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragment, 1, (const char**)&fShader, NULL);
	glCompileShader(fragment);
	checkCompileErrors(fragment, "FRAGMENT");

	unsigned int ID = glCreateProgram();
	glAttachShader(ID, vertex);
	glAttachShader(ID, fragment);

	glLinkProgram(ID);
	checkCompileErrors(ID, "PROGRAM");

	glDeleteShader(vertex);
	glDeleteShader(fragment);
	free(vShader);
	free(fShader);
	return ID;
}

void checkCompileErrors(GLuint shader, char* type) {
	GLint success;
	GLchar infoLog[1024];
	if (strcmp(type, "PROGRAM")) {
		glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
		if (!success) {
			glGetShaderInfoLog(shader, 1024, NULL, infoLog);
			printf("%s\n%s\n", type, infoLog);
		}
	} else {
		glGetProgramiv(shader, GL_LINK_STATUS, &success);
		if (!success) {
			glGetProgramInfoLog(shader, 1024, NULL, infoLog);
			printf("%s\n%s\n", type, infoLog);
		}
	}
}

void setRes(unsigned int ID, char* name, float xy[2]) {
			glUniform2f(glGetUniformLocation(ID, name), xy[0], xy[1]); // I didn't want to read documentation to figure out how to pass in the whole array at once so :] 
}

void setPos(unsigned int ID, char* name, float xyz[3]) {
			glUniform3f(glGetUniformLocation(ID, name), xyz[0], xyz[1], xyz[2]);
}

void setTime(unsigned int ID, char* name, float t) {
			glUniform1f(glGetUniformLocation(ID, name), t);
}

void useShader(unsigned int ID) {
	glUseProgram(ID);
}

