
CC = gcc
WCC = x86_64-w64-mingw32-gcc

CFLAGS  = -lGL -lGLU -lglfw3 -lX11 -lXxf86vm -lXrandr -lpthread -lXi -ldl -lXinerama -lXcursor -lm -lpng
WFLAGS = -I/mingw64/include/ -L/mingw64/lib -lglfw3dll -lopengl32

default:  main.o glad.o shader.o fft.o ui.o audioStream.o
	$(CC) main.o glad.o shader.o fft.o ui.o audioStream.o -o arch64 $(CFLAGS)  
windows: wmain.o wglad.o wshader.o 
	$(WCC) main.o glad.o shader.o -o win64.exe $(WFLAGS)

main.o:  main.c
	$(CC) -c main.c

glad.o:  glad.c 
	$(CC) -c glad.c

ui.o:	./ui/ui.c
	$(CC) -c ./ui/ui.c

audioStream.o:	./audio/audioStream.c
	$(CC) -c ./audio/audioStream.c

shader.o: ./shader/shader.c
	$(CC) -c ./shader/shader.c

fft.o: ./audio/fft.c
	$(CC) -c ./audio/fft.c

wmain.o:  main.c
	$(WCC) -c main.c

wglad.o:  glad.c 
	$(WCC) -c glad.c

wshader.o: ./shader/shader.c
	$(WCC) -c ./shader/shader.c

clean: 
	$(RM) count *.o *~
