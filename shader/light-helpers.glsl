vec3 normal(in vec3 p) {
    vec2 e = vec2(1.0, -1.0) * 0.0001; // epsilon
    return normalize(
      e.xyy * scene(p + e.xyy).w +
      e.yyx * scene(p + e.yyx).w +
      e.yxy * scene(p + e.yxy).w +
      e.xxx * scene(p + e.xxx).w);
}

vec4 marchLight(vec3 rd, vec3 p, vec3 lo, vec3 col, float str) {
	vec3 ld = normalize(lo-p);
	vec3 nrm = normal(p);
	vec3 pnt = vec3(0.);
	float depth = MIN_DIST;
	float md = MAX_DIST;
	for (int i=0; i<255; i++) {
		pnt = p+nrm + depth*ld;
		float d = scene(pnt).w;
		if (d < md) md = d;
		depth += d;
		if (d < ACC || depth > MAX_DIST) break;
	}
	float c = clamp(dot(ld, nrm), 0.25, 1.)*md + 0.2; // diffuse
	c += 0.6*pow(clamp(dot(reflect(-ld, nrm), rd), 0., 1.), 8.); // specular 
	c += 0.75*pow(clamp(1. - dot(nrm, -rd), 0., 1.), 1.); // fresnel
	c /= str*abs(length(lo-p));
	//col -= md*c/5.;
	return vec4(col, c);
}
