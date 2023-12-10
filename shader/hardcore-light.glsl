vec3 skyCol = vec3(0.0, 0.0, 0.0);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	vec4 rt;
	vec3 lo = vec3(10., -3., 10.);
	vec3 lcol = vec3(.1, 0., 0.);
	float str = 0.25;
	rt = marchLight(rd, p, lo, lcol, str);

	return rt; 
}
