#version 330 core
layout (location = 0) in vec3 aPos;

out vec2 res;
out vec2 cam;
out vec3 cOff;
out float iTime;

uniform vec2 iRes;
uniform vec2 mPos;
uniform vec3 pos;
uniform float time;

void main() {
	res = iRes;
	cOff = pos;
	cam = mPos;
	iTime = time;
    	gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
