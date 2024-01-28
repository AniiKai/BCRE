vec4 cubering(vec3 p) {
	vec4 c = cube(p, vec3(1., .5, 1.), vec3(3.), vec3(.25));
	for (int i=1; i<8; i++) {
		vec4 c1 = cube(p*rx(i*PI/4), vec3(1., .5, 1.), vec3(3.), vec3(.25));
		c = vmin(c, c1);
	}
	c.xyz += vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	return c;
}


vec4 scene(vec3 p) {
	p = repeat(p, vec3(50.));

	vec4 pyr1 = pyramid(p, vec3(5., 1., 5.), vec3(0., -2., -0.), vec3(.1, .1, .1));
	//vec4 sph = sphere(p, vec3(.1), vec3(-1., 5., -1.), vec3(1., 0., 0.));
	//pyr1 = vmin(pyr1, sph);
	vec4 cubes = cubering(p * ry(PI/4) * rx(PI/8) * rz(PI/8) + vec3(-10., 0., -10.)*ry(PI/4)*rx(PI/8)*rz(PI/8));

	return svmin(cubes, pyr1, 0.9);
}

vec3 skyCol = vec3(.09, .007, .0);
float fogPow = -0.00003;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(-1., 4., -1.);
	vec3 lcol = vec3(1., .15, .0);
	float str = 500.;
	return marchLight(rd, p, lo, lcol, str);
}
