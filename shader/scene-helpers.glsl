#version 330 core
out vec4 FragColor;

in vec2 res;
in vec2 cam;
in vec3 cOff;
in float iTime;

const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float ACC = 0.00001;
const float PI = 3.14159;

// NOISE SHIT ###################################3
// Pseudo random number generator. 
float hash( vec2 a )
{

    return fract( sin( a.x * 3433.8 + a.y * 3843.98 ) * 45933.8 );

}

// Value noise courtesy of BigWingz 
// check his youtube channel he has
// a video of this one.
// Succint version by FabriceNeyret
float snoise( vec2 U )
{
    vec2 id = floor( U );
          U = fract( U );
    U *= U * ( 3. - 2. * U );  

    vec2 A = vec2( hash(id)            , hash(id + vec2(0,1)) ),  
         B = vec2( hash(id + vec2(1,0)), hash(id + vec2(1,1)) ),  
         C = mix( A, B, U.x);

    return mix( C.x, C.y, U.y );
}
//###############################################
mat3 rx(float t) {
	return mat3(
		vec3(1., .0, .0),
		vec3(.0, cos(t), -sin(t)),
		vec3(.0, sin(t), cos(t))
		   );
}

mat3 ry(float t) {
	return mat3(
		vec3(cos(t), .0, sin(t)),
		vec3(.0, 1., .0),
		vec3(-sin(t), .0, cos(t))
		   );
}

mat3 rz(float t) {
	return mat3(
		vec3(cos(t), -sin(t), .0),
		vec3(sin(t), cos(t), .0),
		vec3(.0, .0, 1.)
		   );
}

mat3 id() {
	return mat3(
		vec3(1., 0., 0.),
		vec3(0., 1., 0.),
		vec3(0., 0., 1.)
		   );
}




vec4 sphere(vec3 p, float r, vec3 off, vec3 col) {
	return vec4(col, length(p - off) - r);
}

vec4 cube(vec3 p, float r, vec3 off, vec3 col) {
	return vec4(col, max(abs(p.x - off.x), max(abs(p.y - off.y), abs(p.z - off.z))) - r);
}
/*
vec4 pyramid(vec3 p, float r, vec3 off, vec3 col) {
	return vec4(col, cd
}
*/

vec4 vmin(vec4 a, vec4 b) {
	return a.w < b.w ? a : b;
}

vec4 vmax(vec4 a, vec4 b) {
	return a.w > -b.w ? a : vec4(b.x, b.y, b.z, b.w*-1);
}

vec4 svmin(vec4 d1, vec4 d2, float k) {
  float h = clamp( 0.5 + 0.5*(d2.w-d1.w)/k, 0.0, 1.0 );
  return mix( d2, d1, h ) - k*h*(1.0-h);
}

vec4 svmax(vec4 d1, vec4 d2, float k) {
  float h = clamp( 0.5 - 0.5*(d2.w+d1.w)/k, 0.0, 1.0 );
  return mix( d2, -d1, h ) + k*h*(1.0-h);
}
vec3 repeat(vec3 p, vec3 c) {
	return mod(p+0.5*c, c)-0.5*c;
}


