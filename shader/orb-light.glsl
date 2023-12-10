vec3 skyCol = vec3(0.2, 0.1, 0.1);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo1 = vec3(1., 1.5, 1.);
	vec3 lcol1 = vec3(.25, .5, 1.);
	float str1 = 0.85;
	vec3 lo = vec3(5., 1., 5.);
	vec3 lcol = vec3(.25, 1., .5);
	float str = 0.85;
	return marchLight(rd, p, lo1, lcol1, str1) + marchLight(rd, p, lo, lcol, str);
}
