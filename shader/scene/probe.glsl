vec4 scene(vec3 p) {

	p *= rx(-1.*PI/4);
	
	vec4 cube1 = cube(p, vec3(.75, 2., .75), vec3(0., 2., 0.), vec3(.5));
	vec4 cube2 = cube(p, vec3(.75), vec3(0., 4.75, 0.), vec3(.5));
	vec4 cube3 = cube(p*rx(PI/4), vec3(.75), rx(-1.*PI/4)*vec3(0., 4.75+.75, .75), vec3(.5));
	cube2 = vmax(cube2, cube3);
	cube3 = cube(p*rx(-1.*PI/4), vec3(.75), rx(PI/4)*vec3(0., 4.75+.75, -0.75), vec3(.5));
	cube2 = vmax(cube2, cube3);
	cube3 = cube(p*rz(PI/4), vec3(.75), rz(-1.*PI/4)*vec3(0.75, 4.75+.75, 0.), vec3(.5));
	cube2 = vmax(cube2, cube3);
	cube3 = cube(p*rz(-1.*PI/4), vec3(.75), rz(PI/4)*vec3(-0.75, 4.75+.75, 0.), vec3(.5));
	cube2 = vmax(cube2, cube3);
	cube1 = vmin(cube1, cube2);

	vec4 cube4 = cube(p, vec3(.05, .75, .05), vec3(0.), vec3(.5));
	vec3 off = vec3(0., -0.15, -0.2);
	vec4 sph1 = sphere(p, vec3(1.), vec3(0., -1.25, -0.5)+off, vec3(.5));
	vec4 sph2 = sphere(p, vec3(1.15), vec3(0., -1.4, -0.65)+off, vec3(.5));
	sph1 = vmax(sph1, sph2);


	cube4 = vmin(cube4, sph1);
	vec4 cube5 = cube(p*rx(-1.*PI/4), vec3(.025, .4, .025), rx(PI/4)*vec3(0., -0.975, -0.3), vec3(.5));
	cube4 = vmin(cube4, cube5);
	
	cube4 = vmin(cube4, cube1);

	mat3 rot = rx(PI/4)*rz(PI/4);
	off = vec3(.865, -1., 1.5);
	vec4 cube6 = cube(p*rot, vec3(.05, 1.5, .05), off+vec3(-1., -1., -1.), vec3(.5));
	sph1 = sphere(p*rot, vec3(.15), off+vec3(-1., -2.5, -1.), vec3(.5));
	vec4 cube7 = cube(p*rot, vec3(1., .2, 1.), off+vec3(-1., -2.675, -1.), vec3(.5));
	cube6 = vmin(cube6, sph1);
	cube6 = vmax(cube6, cube7);

	rot = rx(-PI/4)*rz(-PI/4);
	off = vec3(1.15, -0.9, 0.5);
	vec4 cube61 = cube(p*rot, vec3(.05, 1.5, .05), off+vec3(-1., -1., -1.), vec3(.5));
	sph1 = sphere(p*rot, vec3(.15), off+vec3(-1., -2.5, -1.), vec3(.5));
	cube7 = cube(p*rot, vec3(1., .2, 1.), off+vec3(-1., -2.675, -1.), vec3(.5));
	cube61 = vmin(cube61, sph1);
	cube61 = vmax(cube61, cube7);
	cube6 = vmin(cube6, cube61);

	rot = rx(PI/4)*rz(-PI/4);
	off = vec3(1.15, -1., 1.5);
	cube61 = cube(p*rot, vec3(.05, 1.5, .05), off+vec3(-1., -1., -1.), vec3(.5));
	sph1 = sphere(p*rot, vec3(.15), off+vec3(-1., -2.5, -1.), vec3(.5));
	cube7 = cube(p*rot, vec3(1., .2, 1.), off+vec3(-1., -2.675, -1.), vec3(.5));
	cube61 = vmin(cube61, sph1);
	cube61 = vmax(cube61, cube7);
	cube6 = vmin(cube6, cube61);

	rot = rx(-PI/4)*rz(PI/4);
	off = vec3(.865, -1., 0.5);
	cube61 = cube(p*rot, vec3(.05, 1.5, .05), off+vec3(-1., -1., -1.), vec3(.5));
	sph1 = sphere(p*rot, vec3(.15), off+vec3(-1., -2.5, -1.), vec3(.5));
	cube7 = cube(p*rot, vec3(1., .2, 1.), off+vec3(-1., -2.675, -1.), vec3(.5));
	cube61 = vmin(cube61, sph1);
	cube61 = vmax(cube61, cube7);
	cube6 = vmin(cube6, cube61);

	cube5 = cube(p, vec3(.5, .5, .1), vec3(0., 2.5, -0.8), vec3(.5));
	cube6 = vmin(cube6, cube5);

	cube5 = cube(p, vec3(.5, .5, .25), vec3(-0.8, 2.5, 0.), vec3(.5));
	cube6 = vmin(cube6, cube5);

	cube5 = cube(p, vec3(.05, 1.25, .05), vec3(-1.05, 2.5, 0.), vec3(.5));
	cube6 = vmin(cube6, cube5);

	return vmin(cube6, cube4);

}

vec3 skyCol = vec3(.0, .0, .0);
float fogPow = -0.00003;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(0., 20., -5.);
	vec3 lcol = vec3(1., 1., 1.);
	float str = 50.;
	return marchLight(rd, p, lo, lcol, str); 
}
