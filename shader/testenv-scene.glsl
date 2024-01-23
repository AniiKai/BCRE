vec4 scene(vec3 p) {
	
	vec4 flr = vec4(.8, .8, 1., p.y + 1);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));
	flr.w += snoise(p.xz + iTime);

	vec4 sph1 = sphere(p, vec3(2., 1., 3.), vec3(2., -3., 5.), vec3(0.));

	vec4 tr1 = taurus(p*rx(iTime)*rz(iTime/2), vec3(3., 2., 1.), vec3(5., -1., -5.)*rx(iTime)*rz(iTime/2), vec3(1., .5, .25));
	sph1 = svmin(sph1, tr1, 0.85);

	vec4 l1 = sphere(p, vec3(.2), vec3(5*sin(2*iTime), 8., 5*cos(1.5*iTime)), vec3(0.));
	sph1 = svmin(sph1, l1, 0.65);
	
	vec4 l2 = sphere(p, vec3(.2), vec3(0., 52., 10.), vec3(0.));
	sph1 = svmin(sph1, l2, 0.75);

	vec4 pyr1 = pyramid(p, vec3(5., 1., 5.), vec3(-6., -1., -6.), vec3(1., .3, 1.));
	sph1 = svmin(sph1, pyr1, 0.9);

	vec4 cyl1 = cylinder(p, vec3(1., 1., 1.), vec3(7., 0., 7.), vec3(.3, .8, .8));
	sph1 = svmin(sph1, cyl1, .8);

	vec4 cube1 = cube(p, vec3(1., 2., 1.), vec3(5., 1., 4.), vec3(1., 0., 0.));
	sph1 = svmin(sph1, cube1, .75);


	return svmin(sph1, flr, 0.9);
}
