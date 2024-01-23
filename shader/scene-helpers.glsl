#version 330 core
out vec4 FragColor;

in vec2 res;
in vec2 cam;
in vec3 cOff;
in float iTime;

const float MIN_DIST = 0.0;
const float MAX_DIST = 127.0;
const float ACC = 0.000001;
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
//rotation x y z
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

// SDF ZONE
vec4 sphere(vec3 p, vec3 r, vec3 off, vec3 col) {
	float k0 = length((p-off)/r);
	float k1 = length((p-off)/(r*r));
	return vec4(col, k0*(k0-1.)/k1);
}

vec4 cube(vec3 p, vec3 r, vec3 off, vec3 col) {
	return vec4(col, max(abs(p.x - off.x) - r.x, max(abs(p.y - off.y) - r.y, abs(p.z - off.z) - r.z)));
}

vec4 cylinder(vec3 p, vec3 r, vec3 off, vec3 col) {
	vec2 d = abs(vec2(length(p.xz-off.xz), p.y-off.y)) - r.xz;
	return vec4(col, min(max(d.x, d.y), 0.0) + length(max(d, 0.0)));

}
// this ones infinite in height
vec4 pyramid(vec3 p, vec3 r, vec3 off, vec3 col) {
	float eq = max(abs(p.x - off.x) - r.x, abs(p.z - off.z) - r.z) + (p.y - off.y) - r.y;
	return vec4(col, eq);
}


vec4 taurus(vec3 p, vec3 r, vec3 off, vec3 col) {
	vec2 q = vec2(length(p.xz-off.xz)-r.x, p.y-off.y-r.y);
	return vec4(col, length(q)-r.z);
}

// END OF SDF ZONE


// mixing functions
// hard min function to add shapes together
vec4 vmin(vec4 a, vec4 b) {
	return a.w < b.w ? a : b;
}
// hard max function to cut shapes into eachother (first one cuts)
vec4 vmax(vec4 a, vec4 b) {
	return a.w > -b.w ? a : vec4(b.x, b.y, b.z, b.w*-1);
}
// smooth ver of both, larger the number the harsher it is.
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


