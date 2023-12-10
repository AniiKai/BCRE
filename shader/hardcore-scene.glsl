vec4 cage(vec3 p) {
	p.y += 1;
	vec4 c = sphere(p, 2, vec3(0., 1., 0.), vec3(1., 0., 0.));
	vec4 c1 = cube(p, 2., vec3(0., 0., 0.), vec3(1., 0., 0.));
	vec4 c2 = sphere(p, 2, vec3(0., -1., 0.), vec3(1., 0., 0.));
	c = vmax(c, c1);
	c2 = vmax(c2, c1);
	c = vmin(c, c2);

	vec4 lc;
	for (int i=0; i<20; i++) {
		for (int j=0; j<8; j++) {
			lc = cube(p, 0.1, vec3(1.6*cos(PI/4*j), 1.9-(0.2*i), 1.6*sin(PI/4*j)), vec3(1., 0., 0.));
			c = vmin(c, lc);
		}
	}
	return c;
}

vec4 scene(vec3 p) {
	vec4 flr = vec4(0.2, 0.1, 0.1, p.y + 10.);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	vec4 rf = vec4(0.2, 0.1, 0.1, 4. - p.y);
	rf.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	flr = vmin(flr, rf);
	vec4 c = cage(p);
	vec4 c2 = cage(p+vec3(10., -1., -6.));
	c = vmin(c, c2);


	return vmin(flr, c);
}
