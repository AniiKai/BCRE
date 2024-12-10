vec4 scene(vec3 p) {
	vec4 flr = vec4(0., 0., 1., p.y + 1.);
	flr.w += snoise(p.xz)*0.25;
	vec4 sph = pyramid(vec3(p.x, 0.5*p.y, p.z), vec3(5., 10., 5.), vec3(0., 0., 10.), vec3(0., .5, 0.));
	sph.w += snoise(p.xz*3.)*.2;
	vec4 c1 = cube(p, vec3(1., 10., 1.), vec3(5., 5., 5.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(5., 3., 1.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(0., 4., 3.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(0., 2., -1.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(-4., 6., 6.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(-8., 3., 2.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);

	c1 = cube(p, vec3(1., 20., 1.), vec3(-5., 5., 15.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(-9., 3., 15.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(-5., 4., 10.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	c1 = cube(p, vec3(1., 20., 1.), vec3(-9., 2., 10.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
/*	
	c1 = cube(p, vec3(1., 50., 1.), vec3(-5., 0., 5.), vec3(.5, .5, .5));
	sph = vmin(sph, c1);
	*/

	vec4 sph1 = sphere(p, vec3(2.), vec3(20., 75., 20.), vec3(1.));
	sph = vmin(sph, sph1);
	return vmin(flr, sph); 
}

vec3 skyCol = vec3(0.2, 0.35, .8);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(15., 75., 15.);
	vec3 lcol = vec3(1., 1., 1.);
	float str = 1500.;
	return marchLight(rd, p, lo, lcol, str);
}
