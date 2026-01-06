vec4 scene(vec3 p) {
	//vec4 flr = vec4(vec3(.1), p.y + 10.);
	vec4 flr = vec4(1.);

	vec4 p1 = pyramid(p * ry(iTime), vec3(5.), vec3(0., -10., 0.) * ry(iTime), vec3(.8));
	flr = vmin(flr, p1);

	vec4 d1 = taurus(p * ry(iTime) * rx(cos(2*iTime)), vec3(1., .5, .5), vec3(0., 0.5, 0.) * ry(iTime) * rx(cos(2*iTime)), vec3(.5));
	flr = vmin(flr, d1);

	vec4 sph = sphere(p, vec3(.75), vec3(4*(sin(PI*iTime) + 1), 4*(sin(PI*iTime) + 1) - 7., 0.) * ry(-iTime), vec3(.9));
	flr = svmin(flr, sph, 0.3);
	
	sph = sphere(p, vec3(.75), vec3(-4*(sin(PI*iTime + PI/2) + 1), 4*(sin(PI*iTime + PI/2) + 1) - 7., 0.) * ry(-iTime), vec3(.9));
	flr = svmin(flr, sph, 0.3);

	sph = sphere(p, vec3(.75), vec3(0., 4*(sin(PI*iTime + PI) + 1) - 7., 4*(sin(PI*iTime + PI) + 1)) * ry(-iTime), vec3(.9));
	flr = svmin(flr, sph, 0.3);
	
	sph = sphere(p, vec3(.75), vec3(0., 4*(sin(PI*iTime + PI * 3. / 4.) + 1) - 7., -4*(sin(PI*iTime + PI * 3. / 4.) + 1)) * ry(-iTime), vec3(.9));
	flr = svmin(flr, sph, 0.3);

	return flr;
}


vec3 skyCol = vec3(0.0, 0.0, 0.1);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo1 = vec3(0., 2., 0.);
	vec3 lcol1 = vec3(.25, .5, 1.);
	float str1 = 0.75;
	vec3 lo = vec3(0., 15., 0.);
	vec3 lcol = vec3(.25, 1., .5);
	float str = 7.;
	return marchLight(rd, p, lo1, lcol1, str1) + marchLight(rd, p, lo, lcol, str);
}
