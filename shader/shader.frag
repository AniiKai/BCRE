vec4 march(vec3 ro, vec3 rd) {
	vec4 depth = vec4(0.0, 0.0, 0.0, MIN_DIST);
	vec3 p = vec3(0.0, 0.0, 0.0);
	for (int i=0; i<255; i++) {
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
	vec3 ro = vec3(0.0, 0.0, 5.0) + cOff;
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
			col = vec3(l.w)*vec3(d2l.w)*(vec3(1.)+d.xyz+(0.75*l.xyz));
		} else {
			//col = vec3(l.w)*(vec3(1.)+d.xyz+l.xyz);
			col = (vec3(l.w))*(vec3(1.)+d.xyz+(0.75*l.xyz)+(0.5*skyCol));
		}
		col = mix(col, skyCol, 1. - exp(fogPow * d.w * d.w * d.w));
	} else {
		//vec4 sun = light(ro + d.w*rd);
		//col = vec3(0.9, 0.9, 1.) + 0.02*sun.w*(vec3(1.)+sun.xyz);
		col = skyCol;
	}
	float exposure = 1.5;
	col = vec3(1.0) - exp(-col * exposure); 
	FragColor = vec4(col.x, col.y, col.z, 1.0);
	float gamma = 0.5;
	FragColor.xyz = pow(FragColor.xyz, vec3(1./gamma));
}
