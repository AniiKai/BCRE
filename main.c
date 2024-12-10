// making this into a c file soon!
#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include <cglm/cglm.h>

#include "shader/shader.h"

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow *window);

// settings
const unsigned int SCR_WIDTH = 1920;
const unsigned int SCR_HEIGHT = 1080;


double cursorPosX;
double cursorPosY;
double xinit;
double yinit;
double* newPosX;
double* newPosY;
double sensitivity = 0.001;
vec3 pos = {0.0f, 0.0f, 0.0f};

int main() {
	// initialize window variables
	glfwInit();
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	glfwWindowHint(GLFW_SAMPLES, 4);
#ifdef __APPLE__
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
	int fc = 0;
	printf("Run in fullscreen? 0=YES, 1=NO\n");
	printf("INPUT >> ");
	scanf("%d", &fc);

	char* ps = (char*)calloc(1024, sizeof(char));
	printf("which program would you like to run?\n");
	printf("1): orb\t2): liminal cover\t3): temperate cover\t4): hardcore cover\t5): test environment\t6): Ravers Cover\n7): Promised Land\t8): Abyss 1\t9): Abyss 2");
	printf("\nINPUT >> ");
	int ch;
	scanf("%d", &ch);
	switch(ch) {
		case 1:
			strcat(ps, "shader/scene/orb.glsl");
			break;
		case 2:
			strcat(ps, "shader/scene/mhouse.glsl");
			break;
		case 3:
			strcat(ps, "shader/scene/temperate.glsl");
			break;
		case 4:
			strcat(ps, "shader/scene/hardcore.glsl");
			break;
		case 5:
			strcat(ps, "shader/scene/testenv.glsl");
			break;
		case 6:
			strcat(ps, "shader/scene/raver.glsl");
			break;
		case 7:
			strcat(ps, "shader/scene/promised.glsl");
			break;
		case 8:
			strcat(ps, "shader/scene/abyss1.glsl");
			break;
		case 9:
			strcat(ps, "shader/scene/abyss2.glsl");
			break;
		case 10:
			strcat(ps, "shader/scene/probe.glsl");
			break;
		default:
			strcat(ps, "shader/scene/orb.glsl");
			break;
	}
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

	
	//Shader testShader("shader/defaultShader.vert", "shader/defaultShader.frag");
	unsigned int shader = createShader(ps);
	free(ps);
	// create buffer objects
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

	//testShader.use();
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
	cursorPosX = 0;
	cursorPosY = 0;
	glfwSetCursorPos(window, xinit, yinit);
	glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_HIDDEN);
	float aspect[2] = { (float)SCR_WIDTH, (float)SCR_HEIGHT};	
	setRes(shader, "iRes", aspect); 



	double previousTime = glfwGetTime();
	int frames = 0;
	// openGL window loop
	while (!glfwWindowShouldClose(window)) {
		double currentTime = glfwGetTime();
		frames++;
		if (currentTime - previousTime >= 1.0) { // get simulation fps
			printf("fps: %d\n", frames);
			frames = 0;
			previousTime = currentTime;
		}
		

		glClearColor(0.0f, 0.0f, 0.1f, 1.0f); // background color 
		glClear(GL_COLOR_BUFFER_BIT);
		
		processInput(window); // process user input
				      
		useShader(shader);
		float mPos[2] = { (float)cursorPosX, (float)cursorPosY };
		if (ch == 9) {
			float pos0[2] = {M_PI_2, 0.0};
			vec3 mvPos0 = {21.5*sin(0.1*(float)glfwGetTime()) - 18., 0.0, -5.0};
			setRes(shader, "mPos", pos0);
			//setRes(shader, "mPos", mPos);
			setPos(shader, "pos", mvPos0);
		} else {
			setRes(shader, "mPos", mPos);
			setPos(shader, "pos", pos);
		}
		setTime(shader, "time", (float)glfwGetTime());
		glBindVertexArray(VAO);
		glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
		// swap render buffer 
		glfwSwapBuffers(window);
		glfwPollEvents();

	}
	free(newPosX);
	free(newPosY);
	glBindVertexArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	/*
	glDeleteVertexArrays(1, &VAO);
	glDeleteBuffers(1, &VBO);
	glDeleteBuffers(1, &EBO);
	glDeleteProgram(shader);
	*/
	glfwTerminate();
	return 0;

}

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
	/*
	if (glfwGetKey(window, GLFW_KEY_LEFT) == GLFW_PRESS)
		*cursorPosX += 0.05;
	if (glfwGetKey(window, GLFW_KEY_RIGHT) == GLFW_PRESS)
		*cursorPosX -= 0.05;
	if (glfwGetKey(window, GLFW_KEY_UP) == GLFW_PRESS)
		*cursorPosY += 0.05;
	if (glfwGetKey(window, GLFW_KEY_DOWN) == GLFW_PRESS)
		*cursorPosY -= 0.05;
	*/
	glfwGetCursorPos(window, newPosX, newPosY);
	cursorPosX += (xinit - *newPosX) * sensitivity;
	cursorPosY += (yinit - *newPosY) * sensitivity;
	glfwSetCursorPos(window, xinit, yinit);
	

	
}

void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
	// set the buffer size 
	glViewport(0, 0, width, height);

}




