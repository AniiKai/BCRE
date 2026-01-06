vec4 ringOf(vec3 p, vec3 pos, int num);
vec4 scene(vec3 p) {
	vec4 flr = vec4(0.1, 0.1, 0.1, p.y + 10.);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	vec4 c1 = ringOf(p, vec3(0.), 36);
	vec4 c2 = ringOf(p, vec3(0., 0., -1.), 36);
	c1 = vmin(c1, c2);
	c2 = ringOf(p, vec3(0., 0., -2.), 36);
	c1 = vmin(c1, c2);
	c2 = ringOf(p, vec3(0., 0., -3.), 36);
	c1 = vmin(c1, c2);
	c2 = ringOf(p, vec3(0., 0., -4.), 36);
	c1 = vmin(c1, c2);
	c2 = ringOf(p, vec3(0., 0., -5.), 36);
	c1 = vmin(c1, c2);
	c2 = ringOf(p, vec3(0., 0., -6.), 36);
	c1 = vmin(c1, c2);
	flr = vmin(flr, c1);
	return flr;
}
vec4 ringOf(vec3 p, vec3 pos, int num) {
	vec4 c = cube(p, vec3(.125), pos+vec3(PI, 0, 0), vec3(1.));
	for (int i=1; i<num; i++) {
		vec4 c1 = cube(p, vec3(.125), pos+vec3(PI*cos(2*i*PI/(num)), PI*sin(2*i*PI/(num)), 0), vec3(1.));
		c = vmin(c, c1);
	}
	return c;
}


vec3 skyCol = vec3(0.1, 0.1, 0.1);
float fogPow = -0.00001;
vec4 light(vec3 rd, vec3 p) {
	//p = repeat(p, vec3(8., 20., 8.));
	vec3 lo = vec3(0., 10., 0.);
	vec3 lcol = vec3(1., 1., 1.);
	float str = 10.;
	return marchLight(rd, p, lo, lcol, str);
}
