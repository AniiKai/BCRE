vec4 name(vec3 p);
vec4 line(vec3 p, vec3 pos, vec3 dir, int len);
vec4 scene(vec3 p) {
	vec4 flr = vec4(0.1, 0.1, 0.1, p.y + 10.);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	flr = vmin(flr, name(p+vec3(0., -4., 0.)));
	float c = cos(iTime*2);
	float s = sin(iTime*2);
	vec4 t1 = taurus(p*rx(iTime*2)*rz(iTime*2), (clamp(c - 0.5, 0., 1.)*2*-1 + 1)*vec3(1., .5, .5), rz(-2*iTime)*rx(-2*iTime)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	vec4 t3 = cube(p*ry(-2*iTime), clamp(c, 0., 1.)*vec3(3., 3., .2), ry(2*iTime)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	t1 = svmin(t3, t1, 4.0*clamp(c, 0., 1.));

	c = cos(PI/2 + iTime*2);
	s = sin(PI/2 + iTime*2);
	vec4 t2 = cube(p*rx(iTime*2.5 + 1)*rz(iTime*2.5 + 1), (clamp(c - 0.5, 0., 1.)*2*-1 + 1)*vec3(.75, .75, .75), rz(-2.5*iTime - 1)*rx(-2.5*iTime - 1)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	t3 = cube(p*ry(-2*iTime - PI/2), clamp(c, 0., 1.)*vec3(3., 3., .2), ry(2*iTime + PI/2)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	t2 = svmin(t3, t2, 4.0*clamp(c, 0., 1.));
	t1 = vmin(t1, t2);

	c = cos(PI + iTime*2);
	s = sin(PI + iTime*2);
	t2 = cylinder(p*rx(iTime*1.5 - 1)*rz(iTime*1.5 - 1), (clamp(c - 0.5, 0., 1.)*2*-1 + 1)*vec3(1., .5, .5), rz(-1.5*iTime + 1)*rx(-1.5*iTime + 1)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	t3 = cube(p*ry(-2*iTime - PI), clamp(c, 0., 1.)*vec3(3., 3., .2), ry(2*iTime + PI)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	t2 = svmin(t3, t2, 4.0*clamp(c, 0., 1.));
	t1 = vmin(t1, t2);

	c = cos(3*PI/2 + iTime*2);
	s = sin(3*PI/2 + iTime*2);
	t2 = sphere(p*rx(iTime*2.75 + .5)*rz(iTime*2.75 + .5), (clamp(c - 0.5, 0., 1.)*2*-1 + 1)*vec3(1., .75, .75), rz(-2.75*iTime - .5)*rx(-2.75*iTime - .5)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	t3 = cube(p*ry(-2*iTime - 3*PI/2), clamp(c, 0., 1.)*vec3(3., 3., .2), ry(2*iTime + 3*PI/2)*vec3(6*s + 6, -2., 6*c), vec3(1.));
	t2 = svmin(t3, t2, 4.0*clamp(c, 0., 1.));
	t1 = vmin(t1, t2);
	/*
	vec4 c1 = cube(p, vec3(3., 3., .2), vec3(6., -2., 6.), vec3(1.));
	t1 = svmin(t1, c1, 3.);
	*/
	//t1.w += snoise(5.*p.xy)*0.05;

	return svmin(flr, t1, 0.9);
}

vec4 name(vec3 p) {
	// B
	vec4 c = cube(p, vec3(.125), vec3(.25, 1., -5.), vec3(.5));
	vec4 c1 = cube(p, vec3(.125), vec3(.5, 0.75, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(.5, .5, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(.25, .25, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = line(p, vec3(0., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(0.5, 0., -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(0.5, -0.25, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(0.25, -0.5, -5.), vec3(.5));
	c = vmin(c, c1);

	// L
	c1 = line(p, vec3(1., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(1.25, -0.5, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(1.5, -0.5, -5.), vec3(.5));
	c = vmin(c, c1);

	// A
	c1 = line(p, vec3(2., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(2.25, 1., -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(2.25, .25, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = line(p, vec3(2.5, 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);

	// D
	c1 = line(p, vec3(3., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(3.25, 1., -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(3.25, -.5, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = line(p, vec3(3.5, .75, -5.), vec3(0, -1, 0), 5);
	c = vmin(c, c1);
	
	// E
	c1 = line(p, vec3(4., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = line(p, vec3(4.25, 1., -5.), vec3(1., 0., 0), 2);
	c = vmin(c, c1);
	c1 = line(p, vec3(4.25, .25, -5.), vec3(1., 0., 0), 2);
	c = vmin(c, c1);
	c1 = line(p, vec3(4.25, -.5, -5.), vec3(1., 0., 0), 2);
	c = vmin(c, c1);

	// N
	c1 = line(p, vec3(5., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = line(p, vec3(5.25, .75, -5.), vec3(0, -1, 0), 5);
	c = vmin(c, c1);
	c1 = line(p, vec3(5.5, 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	
	// S
	c1 = line(p, vec3(7., 1., -5.), vec3(0, -1, 0), 4);
	c = vmin(c, c1);
	c1 = line(p, vec3(7.25, 1., -5.), vec3(1, 0, 0), 2);
	c = vmin(c, c1);
	c1 = line(p, vec3(7.5, 0.25, -5.), vec3(0, -1, 0), 4);
	c = vmin(c, c1);
	c1 = line(p, vec3(7.0, -.5, -5.), vec3(1, 0, 0), 2);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(7.25, .25, -5.), vec3(.5));
	c = vmin(c, c1);

	// A
	c1 = line(p, vec3(8., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(8.25, 1., -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(8.25, .25, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = line(p, vec3(8.5, 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);

	// W
	c1 = line(p, vec3(9., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = line(p, vec3(9.25, 0., -5.), vec3(0, -1, 0), 2);
	c = vmin(c, c1);
	c1 = line(p, vec3(9.5, 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);

	// A
	c1 = line(p, vec3(10., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(10.25, 1., -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(10.25, .25, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = line(p, vec3(10.5, 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	 
	// T
	c1 = line(p, vec3(11.25, .75, -5.), vec3(0, -1, 0), 6);
	c = vmin(c, c1);
	c1 = line(p, vec3(11, 1., -5.), vec3(1, 0, 0), 3);
	c = vmin(c, c1);

	// S
	c1 = line(p, vec3(12., 1., -5.), vec3(0, -1, 0), 4);
	c = vmin(c, c1);
	c1 = line(p, vec3(12.25, 1., -5.), vec3(1, 0, 0), 2);
	c = vmin(c, c1);
	c1 = line(p, vec3(12.5, 0.25, -5.), vec3(0, -1, 0), 4);
	c = vmin(c, c1);
	c1 = line(p, vec3(12.0, -.5, -5.), vec3(1, 0, 0), 2);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(12.25, .25, -5.), vec3(.5));
	c = vmin(c, c1);
	
	// K
	c1 = line(p, vec3(13., 1., -5.), vec3(0, -1, 0), 7);
	c = vmin(c, c1);
	c1 = cube(p, vec3(.125), vec3(13.25, .25, -5.), vec3(.5));
	c = vmin(c, c1);
	c1 = line(p, vec3(13.5, 1., -5.), vec3(0, -1, 0), 3);
	c = vmin(c, c1);
	c1 = line(p, vec3(13.5, 0., -5.), vec3(0, -1, 0), 3);
	c = vmin(c, c1);

	// Y
	c1 = line(p, vec3(14., 1., -5.), vec3(0, -1, 0), 3);
	c = vmin(c, c1);
	c1 = line(p, vec3(14.5, 1., -5.), vec3(0, -1, 0), 3);
	c = vmin(c, c1);
	c1 = line(p, vec3(14.25, .25, -5.), vec3(0, -1, 0), 4);
	c = vmin(c, c1);
	
	return c;
}

vec4 line(vec3 p, vec3 pos, vec3 dir, int len) {
	vec4 c = cube(p, vec3(.125) + .125*abs(dir)*(len-1), pos + dir*vec3(.25)*((len-1)/2.0), vec3(.5));
	return c;
}


vec3 skyCol = vec3(0.1, 0.1, 0.1);
float fogPow = -0.00001;
vec4 light(vec3 rd, vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo = vec3(6., 10., 0.);
	vec3 lcol = vec3(1., 1., 1.);
	float str = 10.;
	vec3 lo1 = vec3(6., -5., 0.);
	vec3 lcol1 = vec3(1., 1., 1.);
	float str1 = 2.;
	return marchLight(rd, p, lo, lcol, str) + marchLight(rd, p, lo1, lcol1, str1);
}
