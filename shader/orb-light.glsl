vec3 skyCol = vec3(0.9, 0.9, 1.);
float fogPow = -0.000001;
vec4 light(vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo1 = vec3(1., 2., 1.);
	vec3 lcol1 = vec3(.25);
	float str1 = 0.5;
	vec3 lo = vec3(5., 1., 5.);
	vec3 lcol = vec3(.25);
	float str = 0.25;
	return marchLight(p, lo1, lcol1, str1) + marchLight(p, lo, lcol, str);
}
