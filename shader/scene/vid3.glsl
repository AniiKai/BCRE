vec4 scene(vec3 p) {
	vec4 flr = vec4(0.1, 0.1, 0.1, p.y + 4.);

	vec4 s1 = sphere(p, vec3(6.), vec3(0., -2., 0.), vec3(1.));
	flr = vmax(flr, s1);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	vec4 c1 = cube(p * rx(2*PI*sin(iTime)) * rz(2*PI*cos(iTime)), vec3(.5), vec3(0., -3., 0.) * rx(2*PI*sin(iTime)) * rz(2*PI*cos(iTime)), vec3(.5));  
	flr = vmin(flr, c1);
	vec4 s2 = sphere(p, vec3(.2), vec3(0.2*cos(iTime * PI), -3. + 0.2*sin(iTime * PI), 3.*sin(iTime)), vec3(.5));
	flr = svmin(flr, s2, 0.8);

	s2 = sphere(p, vec3(.2), vec3(0.2*cos(iTime * PI + PI), -3. + 0.2*sin(iTime * PI + PI), 3.*sin(iTime + PI)), vec3(.5));
	flr = svmin(flr, s2, 0.8);

	return flr;
}


vec3 skyCol = vec3(0.2, 0.1, 0.1);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo1 = vec3(0., -5., 0.);
	vec3 lcol1 = vec3(.25, .5, 1.);
	float str1 = 1.5;
	vec3 lo = vec3(0., 15., 0.);
	vec3 lcol = vec3(.25, 1., .5);
	float str = 10.;
	return marchLight(rd, p, lo1, lcol1, str1) + marchLight(rd, p, lo, lcol, str);
}
