vec4 scene(vec3 p) {
	
	vec4 flr = vec4(.8, .8, .8, p.y + 1);

	vec4 cyl1 = cylinder(p, vec3(5., 12., 10.), vec3(0, 0., 0.), vec3(0.));

	flr = vmax(flr, cyl1);
	
	vec4 sph1 = sphere(p, vec3(.5), vec3(2., 0., 2.), vec3(1.));
	flr = vmin(flr, sph1);
	sph1 = sphere(p, vec3(.5), vec3(-2., 0., 2.), vec3(1.));
	flr = vmin(flr, sph1);
	sph1 = sphere(p, vec3(.5), vec3(-2., 0., -2.), vec3(1.));
	flr = vmin(flr, sph1);
	sph1 = sphere(p, vec3(.5), vec3(2., 0., -2.), vec3(1.));
	flr = vmin(flr, sph1);

	vec3 p1 = p*rz(PI);

	vec4 pyr1 = pyramid(p, vec3(1., 1., 1.), vec3(0., 0., 0.), vec3(1.));
	

	
	

	return vmin(pyr1, flr);
}

vec3 skyCol = vec3(.05, .1, .1);
float fogPow = -0.00003;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(0., -6., 0.);
	vec3 lcol = vec3(.75, 1., 1.);
	float str = 15.;
	return marchLight(rd, p, lo, lcol, str); 
}
