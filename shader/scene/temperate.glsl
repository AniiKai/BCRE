vec4 scene(vec3 p) {
	vec4 flr = vec4(0.1, 0.1, 0.1, p.y+1.);
	//flr.xyz += vec3(0.7*mod(floor(p.x) + floor(p.z), 2.));
	//flr.w += snoise(p.xy/p.z*10.)*0.01;
	vec3 tp = p;
	p *= rz(0.15);
	vec4 s1 = cube(p, vec3(0.1), vec3(1., 1., 1.), vec3(0., 1., 0.));
	s1 = vmin(flr, s1);

	for (int i=0; i<25; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(1., 1.+(i*0.2), 1.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	for (int i=0; i<10; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(1., 1.+(i*0.2*-1.), 1.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	for (int i=0; i<10; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(1.+(i*0.2), 20.*0.2, 1.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	for (int i=0; i<10; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(1.+(i*0.2*-1.), 20.*0.2, 1.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	p = tp;
	p *= rz(-0.21) * ry(0.5);

	for (int i=0; i<25; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(2., 1.+(i*0.2), 5.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	for (int i=0; i<10; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(2., 1.+(i*0.2*-1.), 5.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	for (int i=0; i<10; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(2.+(i*0.2), 20.*0.2, 5.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	for (int i=0; i<10; i++) {
		vec4 s2 = cube(p, vec3(0.1), vec3(2.+(i*0.2*-1.), 20.*0.2, 5.), vec3(0., 1., 0.));
		s1 = vmin(s1, s2);
	}
	return s1;
}

vec3 skyCol = vec3(0.9, 0.9, 1.);
float fogPow = -0.000001;
vec4 light(vec3 rd, vec3 p) {
	vec4 rt;
	vec3 lo = vec3(10., 50., 10.);
	vec3 lcol = vec3(.1);
	float str = 600;
	rt = marchLight(rd, p, lo, lcol, str);
	lo = vec3(1., 3., 10.);
	lcol = vec3(.0, .0, .5);
	str = 3;
	rt += marchLight(rd, p, lo, lcol, str);

	return rt; 
}
