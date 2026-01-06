#include <stdlib.h>
#include <stdio.h>
#include <string.h>
void BCREInitializeProgram(int* fullscreen, int* audioFX, char** audioFile, char** scene, int* render, int* divider) {
	printf("░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓████████▓▒░\n");
	printf("░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░\n");        
	printf("░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░\n");        
	printf("░▒▓███████▓▒░░▒▓█▓▒░      ░▒▓███████▓▒░░▒▓██████▓▒░\n");   
	printf("░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░\n");        
	printf("░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░\n");        
	printf("░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░\n"); 
	printf("\nVersion 0.9 | Created by Bladen Sawatsky\n\n\n");

	*fullscreen = 0;
	printf("Run in fullscreen? 0=YES, 1=NO\n");
	printf("INPUT >> ");
	scanf("%d", fullscreen);

	*divider = 1;
	printf("Divide resolution by specified integer amount (Input 1 for default resolution)\n");
	printf("INPUT >> ");
	scanf("%d", divider);

	*audioFX = 0; 
	printf("Run real time audio effect? 0=YES, 1=NO\n");
	printf("INPUT >> ");
	scanf("%d", audioFX);

	if (*audioFX == 0) {
		printf("Audio to use?\n");
		printf("1): default");
		printf("\nINPUT >> ");
		int choice = 0;
		*audioFile = (char*)calloc(1024, sizeof(char));
		scanf("%d", &choice);
		if (choice == 1) {
			strcat(*audioFile, "audio/audio.wav");
		} else {
			*audioFX = 1;
			printf("Invalid choice!\n");
		}
	}

	*scene = (char*)calloc(1024, sizeof(char));
	printf("which program would you like to run?\n");
	printf("1): orb\t2): liminal cover\t3): temperate cover\t4): hardcore cover\t5): test environment\t6): Ravers Cover\n7): Promised Land\t8): Abyss 1\t9): Abyss 2");
	printf("\nINPUT >> ");
	int ch;
	scanf("%d", &ch);
	switch(ch) {
		case 1:
			strcat(*scene, "shader/scene/orb.glsl");
			break;
		case 2:
			strcat(*scene, "shader/scene/mhouse.glsl");
			break;
		case 3:
			strcat(*scene, "shader/scene/temperate.glsl");
			break;
		case 4:
			strcat(*scene, "shader/scene/hardcore.glsl");
			break;
		case 5:
			strcat(*scene, "shader/scene/testenv.glsl");
			break;
		case 6:
			strcat(*scene, "shader/scene/raver.glsl");
			break;
		case 7:
			strcat(*scene, "shader/scene/promised.glsl");
			break;
		case 8:
			strcat(*scene, "shader/scene/abyss1.glsl");
			break;
		case 9:
			strcat(*scene, "shader/scene/abyss2.glsl");
			break;
		case 10:
			strcat(*scene, "shader/scene/probe.glsl");
			break;
		case 11:
			strcat(*scene, "shader/scene/vid4.glsl");
			break;
		case 12:
			strcat(*scene, "shader/scene/portfolio.glsl");
			break;
		case 13:
			strcat(*scene, "shader/scene/stresstest.glsl");
			break;
		default:
			strcat(*scene, "shader/scene/orb.glsl");
			break;
	}

	*render = 0;
	printf("Render frames to file? 0=YES, 1=NO (previously written files may be overwritten)\n");
	printf("INPUT >> ");
	scanf("%d", render);

}
