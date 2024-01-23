vec3 skyCol = vec3(.09, .007, .0);
float fogPow = -0.00003;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(-1., 4., -1.);
	vec3 lcol = vec3(1., .15, .0);
	float str = 500.;
	return marchLight(rd, p, lo, lcol, str);
}
