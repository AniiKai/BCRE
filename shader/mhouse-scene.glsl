vec4 scene(vec3 p) {
	vec4 flr = vec4(0.15, 0.1, 0.0, p.y + 1.);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	vec4 rf = vec4(0.15, 0.1, 0.0, 3. - p.y);
	rf.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	vec4 s1 = vec4(0.);
	s1 = cube(p, 2., vec3(1., 1., 1.), vec3(1., 1., 0.));
	vec4 m1 = cube(p, 1.5, vec3(1., 1., 3.), vec3(1., 1., 0.));
	s1 = vmax(s1, m1);

	vec4 orb = sphere(p, 0.15, vec3(1., 1., 2.), vec3(1., 0., 1.));
	s1 = vmin(s1, orb);

	vec4 s2 = cube(p, 2., vec3(1., 1., 15.), vec3(1., 1., 0.));
	m1 = cube(p, 1.5, vec3(1., 1., 13.), vec3(1., 1., 0.));
	s2 = vmax(s2, m1);
	s1 = vmin(s1, s2);

	orb = sphere(p, 0.15, vec3(1., 1., 14.), vec3(1., 0., 1.));
	s1 = vmin(s1, orb);

	vec4 s3 = cube(p, 3., vec3(6., 1., 1.), vec3(1., 1., 1.));
	m1 = cube(p, 2., vec3(6., 1., 4.), vec3(1., 1., 1.));
	s3 = vmax(s3, m1);
	s1 = vmin(s1, s3);

	orb = sphere(p, 0.15, vec3(6., 1., 2.5), vec3(1., 0., 1.));
	s1 = vmin(s1, orb);

	vec4 s4 = cube(p, 3., vec3(6., 1., 15.), vec3(1., 1., 1.));
	m1 = cube(p, 2., vec3(6., 1., 12.), vec3(1., 1., 1.));
	s4 = vmax(s4, m1);
	s1 = vmin(s1, s4);

	orb = sphere(p, 0.15, vec3(6., 1., 13.5), vec3(1., 0., 1.));
	s1 = vmin(s1, orb);

	s4 = cube(p, 2., vec3(11., 1., 1.), vec3(0., 1., 1.));
	m1 = cube(p, 1.5, vec3(11., 1., 3.), vec3(0., 1., 1.));
	s4 = vmax(s4, m1);
	s1 = vmin(s1, s4);

	orb = sphere(p, 0.15, vec3(11., 1., 2.), vec3(1., 0., 1.));
	s1 = vmin(s1, orb);

	s4 = cube(p, 2., vec3(11., 1., 15.), vec3(0., 1., 1.));
	m1 = cube(p, 1.5, vec3(11., 1., 13.), vec3(0., 1., 1.));
	s4 = vmax(s4, m1);
	s1 = vmin(s1, s4);

	orb = sphere(p, 0.15, vec3(11., 1., 14.), vec3(1., 0., 1.));
	s1 = vmin(s1, orb);
	s1 += snoise(p.xz*p.y)*0.05;

	s1 = svmin(s1, rf, 0.5);

	return svmin(flr, s1, 0.5);
}
