vec4 scene(vec3 p) {
	vec4 flr = vec4(0.1, 0.1, 0.1, p.y - 12.);

	vec4 s1 = sphere(p, vec3(15.), vec3(0., 0., 0.), vec3(1.));
	flr = vmax(flr, s1);

	vec4 cyl1 = cylinder(p, vec3(.5, 12., 5.), vec3(0.), vec3(1.));
	flr = vmin(flr, cyl1);
	flr.xyz = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.));

	vec4 cube1 = cube(p*rx(cos(iTime*PI/2.))*ry(sin(iTime*PI)), vec3(.5), vec3(10.*sin(iTime*10.), sin(iTime*2.), 10.*cos(iTime*10.))*rx(cos(iTime*PI/2.))*ry(sin(iTime*PI)), vec3(1.));
	flr = vmin(flr, cube1);
	cube1 = cube(p*rx(cos(iTime*PI/2.))*ry(sin(iTime*PI)), vec3(.5), vec3(10.*sin(iTime*10. + PI), cos(iTime*2.), 10.*cos(iTime*10. + PI))*rx(cos(iTime*PI/2.))*ry(sin(iTime*PI)), vec3(1.));
	flr = vmin(flr, cube1);

	return flr;
}


vec3 skyCol = vec3(0.2, 0.1, 0.1);
float fogPow = -0.000002;
vec4 light(vec3 rd, vec3 p) {
	vec3 lo = vec3(0., 12., -5.);
	vec3 lcol = vec3(.25, 1., .5);
	float str = 50.;
	return marchLight(rd, p, lo, lcol, str);
}
