vec3 skyCol = vec3(0.9, 0.9, 1.);
float fogPow = -0.000001;
vec4 light(vec3 p) {
	vec4 rt;
	vec3 lo = vec3(6., 2., 2.);
	vec3 lcol = vec3(.1);
	float str = 0.95;
	rt = marchLight(p, lo, lcol, str);

	lo = vec3(6., 2., 14.);
	rt += marchLight(p, lo, lcol, str);

	lo = vec3(1., 2., 2.);
	rt += marchLight(p, lo, lcol, str);

	lo = vec3(1., 2., 14.);
	rt += marchLight(p, lo, lcol, str);
	
	lo = vec3(11., 2., 2.);
	rt += marchLight(p, lo, lcol, str);

	lo = vec3(11., 2., 14.);
	rt += marchLight(p, lo, lcol, str);

	return rt; 
}
