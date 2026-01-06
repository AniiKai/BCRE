vec3 normal(in vec3 p) {
    vec2 e = vec2(1.0, -1.0) * 0.01; // epsilon
/*
    return normalize(
      e.xyy * scene(p + e.xyy).w +
      e.yyx * scene(p + e.yyx).w +
      e.yxy * scene(p + e.yxy).w +
      e.xxx * scene(p + e.xxx).w
      );
      */
	return normalize(
			(vec3(scene(p+vec3(e.x, 0., 0.)).w, scene(p+vec3(0., e.x, 0.)).w, scene(p+vec3(0., 0., e.x)).w) - scene(p).w) / 1.
			);
}

vec4 marchLight(vec3 rd, vec3 p, vec3 lo, vec3 col, float str) {
	vec3 ld = normalize(lo-p);
	vec3 nrm = normal(p);
	vec3 start = lo-p+nrm;
	vec3 pnt = vec3(0.);
	float depth = MIN_DIST;
	float md = MAX_DIST;
	for (int i=0; i<int(MAX_DIST); i++) {
		pnt = p+nrm + depth*ld;
		float d = scene(pnt).w;
		if (d < md) md = d;
		depth += d;
		if ((lo-pnt).x*start.x < 0 && (lo-pnt).y*start.y < 0 && (lo-pnt).z*start.z < 0) {
			md = 1.0;
			break;
		}
		if (d < ACC || depth > MAX_DIST) break;
	}
	// Phong
	float c = clamp(dot(ld, nrm), 0.25, 1.)*md + 0.2; // diffuse
	c += 0.6*pow(clamp(dot(reflect(-ld, nrm), rd), 0., 1.), 8.); // specular 
	c += 0.75*pow(clamp(1. - dot(nrm, -rd), 0., 1.), 1.); // fresnel
	//c = clamp(c, 0., 1.);
	c *= (str) / (length(lo-p)*length(lo-p));
	//c /= str*abs(length(lo-p)); // light fall off
	//col -= md*c/5.;
	return vec4(col, c);
}

vec4 march(vec3 ro, vec3 rd) {
	vec4 depth = vec4(0.0, 0.0, 0.0, MIN_DIST);
	vec3 p = vec3(0.0, 0.0, 0.0);
	for (int i=0; i<int(MAX_DIST); i++) {
		p = ro + depth.w*rd;
		vec4 d = scene(p);
		depth.w += d.w;
		depth.xyz = d.xyz;
		if (d.w < ACC || depth.w > MAX_DIST) {
			break;
		} 
	}
	return depth;
}
/*
mat4 lookat(vec3 p) {
	vec3 dir = normalize(vec3(p));
	vec3 right = normalize(cross(vec3(0., 1., 0.), dir));
	vec3 up = normalize(cross(dir, right));
	p = normalize(p);
	return mat4(
		vec4(right*-1, dot(right, p)),
		vec4(up, dot(up, p)),
		vec4(dir, dot(dir, p)),
		vec4(0., 0., 0., 1.));
}
vec3 ref(vec3 rj, vec3 nrm) {
	return rj - 2*nrm*(dot(rj, nrm));
}
*/

void main() {
	vec2 uv = (gl_FragCoord.xy - 0.5 * res.xy) / res.y;
	vec3 ro = vec3(0.0, 0.0, 3.0) + cOff;
	vec3 rd = vec3(uv.x, uv.y, -1.0);
	rd *= rx(cam.y) * ry(cam.x);
	//vec4 rtmp = vec4(rd, 0.);
	//rtmp *= lookat(ro);
	//rd = rtmp.xyz;
	vec3 col = vec3(0.0, 0.0, 0.0);
	rd = normalize(rd);
	vec4 d = march(ro, rd);
	if (d.w < MAX_DIST) {
		vec3 np = ro + d.w*rd;
		vec3 nrm = normal(np);
		vec3 ref = reflect(normalize(rd), nrm);
		vec4 d2 = march(np+nrm, ref);
		vec4 l = light(rd, np);
		if (d2.w < MAX_DIST){
			vec4 d2l = light(rd, np+nrm + d2.w*ref);
			d2l *= 2.;
			//col = vec3(l.w)*(vec3(1.)+d.xyz+l.xyz);
			col = vec3(l.w)*vec3(d2l.w)*((0.375*d2l.xyz)+vec3(1.)+0.75*d.xyz+0.25*d2.xyz+(0.375*l.xyz)+0.5*skyCol);
		} else {
			//col = vec3(l.w)*(vec3(1.)+d.xyz+l.xyz);
			col = (vec3(l.w))*(vec3(1.)+d.xyz+(0.75*l.xyz)+0.5*skyCol);
		}
		col = mix(col, skyCol, 1. - exp(fogPow * d.w * d.w * d.w));
	} else {
		//vec4 sun = light(ro + d.w*rd);
		//col = vec3(0.9, 0.9, 1.) + 0.02*sun.w*(vec3(1.)+sun.xyz);
		col = skyCol;
	}
	float x = (gl_FragCoord.x + 200) / (res.x + 200);
	float z = (d.w + 12) / (MAX_DIST + 12);

	float db = 0.4342944819 * 20 * log(spec[int(mix(clamp(z*z*z, 0.0, 1.0), x*x*x, .1) * 1024)] / 1024);
	vec3 vis = clamp(1.1*vec3(-1 * 0.001736 * db*db + 1, -1 * 0.001736 * (db + 30)*(db + 30) + 1, -1 * 0.0007716 * (db + 48) * (db + 48) + 1), vec3(0.0), vec3(1.0));
	col = mix(col, vis, 0.17);

	float exposure = 4.;
	col = vec3(1.0) - exp(-col * exposure); 
	float saturation = .15;
	col = mix(col, pow(col, vec3(4.)), saturation);
	FragColor = vec4(col.x, col.y, col.z, 1.0);
	float gamma = 0.5;
	FragColor.xyz = pow(FragColor.xyz, vec3(1./gamma));
}
