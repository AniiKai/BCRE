vec3 skyCol = vec3(0.7, 0.7, 1.);
float fogPow = -0.000003;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(0., 50., 10.);
	vec3 lcol = vec3(1., .75, .2);
	float str = 0.15;
	vec3 lo2 = vec3(5*sin(2*iTime), 6., 5*cos(1.5*iTime));
	vec3 lcol2 = vec3(0.1, 0.1, 1.);
	float str2 = 0.7;
	return marchLight(rd, p, lo, lcol, str) + marchLight(rd, p, lo2, lcol2, str2);
}
