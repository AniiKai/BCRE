vec4 scene(vec3 p) {
	vec4 flr = vec4(0.1, 0.1, 0.1, p.y + 1.);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	//flr.w += snoise(vec2(p.x, p.y)*p.z*2.) * 0.1;
	vec4 rf = vec4(0.1, 0.1, 0.1, 3. - p.y);
	rf.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	//p = repeat(p, vec3(8., 20., 8.));
	vec4 s1 = cube(p, vec3(2.), vec3(1., 1., 1.), vec3(1., 0., 0.));
	s1.w += snoise(vec2(p.x, p.y)*p.z*2.5) * 0.05;
	vec4 s1s = sphere(p, vec3(1.25), vec3(-0.5, 1., -0.5), vec3(0., 0., 0.));
	s1 = svmax(s1s, s1, 0.5);
	vec4 s2s = sphere(p, vec3(1.25), vec3(2.5, 1., -0.5), vec3(0., 0., 0.));
	s1 = svmax(s2s, s1, 0.5);
	vec4 s3s = sphere(p, vec3(1.25), vec3(-0.5, 1., 2.5), vec3(0., 0., 0.));
	s1 = svmax(s3s, s1, 0.5);
	vec4 s4s = sphere(p, vec3(1.25), vec3(2.5, 1., 2.5), vec3(0., 0., 0.));
	s1 = svmax(s4s, s1, 0.5);
	vec4 s5s = sphere(p, vec3(1.5), vec3(1., 1., 1.), vec3(0., 0., 0.));
	s1 = svmax(s5s, s1, 0.5);

	vec4 cyl1 = cylinder(p, vec3(1.), vec3(6., 2., 6.), vec3(0.));
	s1 = vmin(cyl1, s1);
	vec4 pyr1 = pyramid(p, vec3(1.), vec3(-6., 2., -6.), vec3(0.));
	s1 = vmin(pyr1, s1);
	vec4 tr1 = taurus(p*rx(PI/2), vec3(1., 2., 0.5), vec3(6., 1., -6.)*rx(PI/2), vec3(0.));
	s1 = vmin(tr1, s1);
	vec4 sph1 = sphere(p, vec3(1., 2., 0.5), vec3(-6., 1., 6.), vec3(0.));
	s1 = vmin(sph1, s1);

	vec4 c1 = sphere(p, vec3(0.2), vec3(0.5*cos(iTime*20.)+1., 2.*sin(iTime*0.5)+1., 0.5*sin(iTime*20.)+1.), vec3(1., 0., 0.));
	s1 = svmin(s1, c1, 0.9);
	s1 = svmin(s1, rf, 0.9);

	return svmin(flr, s1, 0.9);
}


vec3 skyCol = vec3(0.2, 0.1, 0.1);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo1 = vec3(1., 1.5, 1.);
	vec3 lcol1 = vec3(.25, .5, 1.);
	float str1 = 1.5;
	vec3 lo = vec3(10., 1., 0.);
	vec3 lcol = vec3(.25, 1., .5);
	float str = 10.;
	return marchLight(rd, p, lo1, lcol1, str1) + marchLight(rd, p, lo, lcol, str);
}
