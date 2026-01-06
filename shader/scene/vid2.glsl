vec4 scene(vec3 p) {
	vec4 flr = vec4(0.1, 0.1, 0.1, p.y + 10.);

	vec4 s1 = sphere(p, vec3(20.), vec3(0.), vec3(1.));
	flr = vmax(flr, s1);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	vec4 don = taurus(p * rx(iTime) * rz(iTime / PI), vec3(5.), vec3(0.), vec3(.5));
	flr = vmin(flr, don);

	return flr;
}


vec3 skyCol = vec3(0.2, 0.1, 0.1);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo1 = vec3(0., -12., 0.);
	vec3 lcol1 = vec3(.25, .5, 1.);
	float str1 = 1.5;
	vec3 lo = vec3(0., 1.5, -10.);
	vec3 lcol = vec3(.25, 1., .5);
	float str = 10.;
	return marchLight(rd, p, lo1, lcol1, str1) + marchLight(rd, p, lo, lcol, str);
}
