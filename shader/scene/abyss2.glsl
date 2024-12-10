vec4 scene(vec3 p) {
	
	vec4 flr = vec4(.8, .8, .8, p.y + 10);

	vec4 wall = vec4(.8, .8, .8, p.x + 1);

	vec4 cyl1 = cylinder(p*rz(PI/2), vec3(5., 50., 50.), vec3(0, 1., 0.), vec3(0.));

	wall = vmax(wall, cyl1);

	flr = vmin(flr, wall);
	
	vec4 sph1 = sphere(p, vec3(.5), vec3(-20., 0., 2.), vec3(1.));
	flr = vmin(flr, sph1);
	sph1 = sphere(p, vec3(.5), vec3(-40., 0., 2.), vec3(1.));
	flr = vmin(flr, sph1);
	sph1 = sphere(p, vec3(.5), vec3(-20., 0., -2.), vec3(1.));
	flr = vmin(flr, sph1);
	sph1 = sphere(p, vec3(.5), vec3(-40., 0., -2.), vec3(1.));
	flr = vmin(flr, sph1);

	vec4 l = sphere(p, vec3(.1), vec3(-5., 1.0, 0.), vec3(1.));
	vec4 l2 = sphere(p, vec3(.1), vec3(-15., 1.0, 0.), vec3(1.));
	flr = vmin(l2, flr);
	vec4 l3 = sphere(p, vec3(.1), vec3(-25., 1.0, 0.), vec3(1.));
	flr = vmin(l3, flr);
	vec4 l4 = sphere(p, vec3(.1), vec3(-35., 1.0, 0.), vec3(1.));
	flr = vmin(l4, flr);
	
	
	return vmin(l, flr);
}

vec3 skyCol = vec3(.05, .1, .1);
float fogPow = -0.00003;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(-5., 1.0, 0.);
	vec3 lcol = vec3(1., 1., 0.35);
	float str = 5.;

	vec3 lo2 = vec3(-15., 1.0, 0.);
	vec3 lcol2 = vec3(1., 1., 0.35);
	float str2 = 5.;
	
	vec3 lo3 = vec3(-25., 1.0, 0.);
	vec3 lcol3 = vec3(1., 1., 0.35);
	float str3 = 5.;

	vec3 lo4 = vec3(-35., 1.0, 0.);
	vec3 lcol4 = vec3(1., 1., 0.35);
	float str4 = 5.;
	return marchLight(rd, p, lo, lcol, str) + marchLight(rd, p, lo2, lcol2, str2) + marchLight(rd, p, lo3, lcol3, str3) + marchLight(rd, p, lo4, lcol4, str4); 
}
