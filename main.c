#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <png.h>

#include <cglm/cglm.h>

#include "shader/shader.h"
#include "audio/audioStream.h"
#include "ui/ui.h"
#include "audio/fft.h"

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow *window);
//void close(float* spectra, FILE* f, double* newPosX, double* newPosY);


// settings
const unsigned int SCR_WIDTH = 1920;
const unsigned int SCR_HEIGHT = 1080;

// can not have static variables once everything is moved into functions must pass everything, create context variables struct to hold it all
double cursorPosX;
double cursorPosY;
double xinit;
double yinit;
double* newPosX;
double* newPosY;
double sensitivity = 0.001;
vec3 pos = {0.0f, 0.0f, 0.0f};

int main() {

	// scene path
	char* ps;
	// fullscreen
	int fc;
	// audio fx
	int afx;
	// audio file
	char* af;
	// render to file
	int r;
	// resolution division
	int div;

	BCREInitializeProgram(&fc, &afx, &af, &ps, &r, &div);
	// initialize window variables
	// create GLFW context ########################
	glfwInit();
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	glfwWindowHint(GLFW_SAMPLES, 4);
#ifdef __APPLE__
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

	// create the window
	GLFWwindow* window; 
	if (fc == 0) {
		window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "BCRE", glfwGetPrimaryMonitor(), NULL);
	} else {
		window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "BCRE", NULL, NULL);
	}
	

	if (window == NULL) {
	    	printf("Failed to create GLFW window");
 	    	glfwTerminate();
	    	return -1;
	}
	
	// set the window as the current window 
	glfwMakeContextCurrent(window);
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
	
	// initialize GLAD
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
		printf("Failed to initialize GLAD");
		return -1;
       	}
	
	// #####################

	
	// Create shaders ####################
	unsigned int texShader = createTexShader();
	unsigned int shader = createShader(ps);
	free(ps);
	// #########################
	// create buffer objects for raymarching shader ###########
	//unsigned int EBO;
	unsigned int VBO;
	unsigned int VAO;
	unsigned int EBO;
	glGenBuffers(1, &EBO);
	glGenVertexArrays(1, &VAO);
	glGenBuffers(1, &VBO);

	float vertices[12] = {
		1.0f, 1.0f, 0.0f,
		1.0f, -1.0f, 0.0f,
		-1.0f, 1.0f, 0.0f,
		-1.0f, -1.0f, 0.0f
	};

	unsigned int indices[6] = {
		0, 1, 2,
		1, 2, 3
	};

	
	// create and assign the test obj to index 1 of the array buffer
	glBindVertexArray(VAO);
	
	glBindBuffer(GL_ARRAY_BUFFER, VBO); // bind current buffer 
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	// ####################
	
	// set texture shader buffer objects and framebuffer ######################
	unsigned int quadVAO, quadVBO, quadEBO;
	glGenVertexArrays(1, &quadVAO);
	glGenBuffers(1, &quadVBO);
	glGenBuffers(1, &quadEBO);

	float quadVertices[] = {
		1.0f, 1.0f, 0.0f,	1.0f, 1.0f,
		1.0f, -1.0f, 0.0f,	1.0f, 0.0f,
		-1.0f, 1.0f, 0.0f,	0.0f, 1.0f,
		-1.0f, -1.0f, 0.0f,	0.0f, 0.0f
	};

	glBindVertexArray(quadVAO);
	glBindBuffer(GL_ARRAY_BUFFER, quadVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(quadVertices), &quadVertices, GL_STATIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, quadEBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5*sizeof(float), (void*)0);
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5*sizeof(float), (void*)(3*sizeof(float)));
	glBindBuffer(GL_ARRAY_BUFFER, 0);


	unsigned int framebuffer;
	glGenFramebuffers(1, &framebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);

	unsigned int textureColorBuffer;
	glGenTextures(1, &textureColorBuffer);

	glBindTexture(GL_TEXTURE_2D, textureColorBuffer);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA16F, (int)(SCR_WIDTH/div), (int)(SCR_HEIGHT/div), 0, GL_RGBA, GL_FLOAT, NULL);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureColorBuffer, 0);
	if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
		printf("FRAMEBUFFER NOT COMPLETE!\n");
	}
	glBindFramebuffer(GL_FRAMEBUFFER, 0);
	// #######################
	
	useShader(texShader);
	setSampler(texShader, "image", 0);

	// set raymarching shader uniforms #########################
	useShader(shader);
	//glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
	//glEnable(GL_BLEND);
	//glEnable(GL_DEPTH_TEST);
	//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	//glEnable(GL_MULTISAMPLE);
	newPosX = (double*)malloc(sizeof(double));
	newPosY = (double*)malloc(sizeof(double));
	xinit = SCR_WIDTH / 2.0;
	yinit = SCR_HEIGHT / 2.0;
	cursorPosX = 0.0;
	cursorPosY = 0.0;
	glfwSetCursorPos(window, xinit, yinit);
	glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_HIDDEN);
	float aspect[2] = { (float)SCR_WIDTH/div, (float)SCR_HEIGHT/div};	
	setRes(shader, "iRes", aspect); 

	// ####################
	

	// Set up audio effect ##########################
	FILE* f;
	float* spectra;
	if (BCREStartAudioStream(afx, &f, &spectra, af) == 0) {
		glfwSetWindowShouldClose(window, true);
	}
	if (afx == 0) free(af);

	int frames = 0;
	int totalFrames = 0;
	int audioFrames = 0;
	char* pixelData = (char*)malloc(SCR_WIDTH*SCR_HEIGHT*3*sizeof(char));
	// ###############################

	// glfw run context #######################
	double previousTime = glfwGetTime();
	// openGL window loop
	while (!glfwWindowShouldClose(window)) {
		char name[1024] = "";
		double currentTime = glfwGetTime();
		
		
		if (BCRESeekAudio(afx, &audioFrames, totalFrames, f, spectra) == 0) glfwSetWindowShouldClose(window, true);	
		frames++;
		totalFrames++;
		if (currentTime - previousTime >= 1.0) { // get simulation fps
			printf("fps: %d\n", frames);
			frames = 0;
			previousTime = currentTime;
		}
		
		glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
		useShader(shader);
		glClearColor(0.0f, 0.0f, 0.1f, 1.0f); // background color 
		glClear(GL_COLOR_BUFFER_BIT);
		
		processInput(window); // process user input
				      
		useShader(shader);
		float mPos[2] = { (float)cursorPosX, (float)cursorPosY };
		setRes(shader, "mPos", mPos);
		setPos(shader, "pos", pos);
		setTime(shader, "time", (float)glfwGetTime() / 25);
		if (afx == 0) setSpectrum(shader, "spec", spectra);

		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);
		glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

		glBindVertexArray(0);
		glBindFramebuffer(GL_FRAMEBUFFER, 0);

		useShader(texShader);
		glClearColor(0.0f, 0.0f, 0.1f, 1.0f); // background color 
		glClear(GL_COLOR_BUFFER_BIT);

		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, textureColorBuffer);
		glBindVertexArray(quadVAO);
		glBindBuffer(GL_ARRAY_BUFFER, quadVBO);
		glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

		BCRERenderCurrentFrame(r, SCR_WIDTH, SCR_HEIGHT, totalFrames, pixelData);

		glBindVertexArray(0);

		// swap render buffer 
		glfwSwapBuffers(window);
		glfwPollEvents();

	}
	// ######################
	// close glfw context ######################
	if (afx == 0 ) {
		free(spectra);
		fclose(f);
	}
	free(pixelData);
	free(newPosX);
	free(newPosY);
	glBindVertexArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glfwTerminate();
	// #########################
	return 0;

}

// move these into glfw run context function ####################3
void processInput(GLFWwindow *window) {
	// close the program if you press the escape key 
	
    	if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
		glfwSetWindowShouldClose(window, true);
	if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS) {
		vec3 mv = {-0.1*sin(cursorPosX), 0.0, -0.1*cos(cursorPosX)};
		glm_vec3_add(pos, mv, pos);
	}
	if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS) {
		vec3 mv = {0.1*sin(cursorPosX), 0.0, 0.1*cos(cursorPosX)};
		glm_vec3_add(pos, mv, pos);
	}
	if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS) {
		vec3 mv = {-0.1*cos(cursorPosX), 0.0, 0.1*sin(cursorPosX)};
		glm_vec3_add(pos, mv, pos);
	}
	if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS) {
		vec3 mv = {0.1*cos(cursorPosX), 0.0, -0.1*sin(cursorPosX)};
		glm_vec3_add(pos, mv, pos);
	}
	glfwGetCursorPos(window, newPosX, newPosY);
	cursorPosX += (xinit - *newPosX) * sensitivity;
	cursorPosY += (yinit - *newPosY) * sensitivity;
	glfwSetCursorPos(window, xinit, yinit);
	

	
}

void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
	// set the buffer size 
	glViewport(0, 0, width, height);
}
// ####################

