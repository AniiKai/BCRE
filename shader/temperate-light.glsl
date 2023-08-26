vec3 skyCol = vec3(0.9, 0.9, 1.);
float fogPow = -0.000001;
vec4 light(vec3 p) {
	vec4 rt;
	vec3 lo = vec3(10., 50., 10.);
	vec3 lcol = vec3(.1);
	float str = 0.1;
	rt = marchLight(p, lo, lcol, str);
	lo = vec3(1., 3., 10.);
	lcol = vec3(.0, .0, .5);
	str = 0.35;
	rt += marchLight(p, lo, lcol, str);

	return rt; 
}
