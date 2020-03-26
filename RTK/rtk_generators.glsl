#ifndef RTK_GENERATORS
#define RTK_GENERATORS

Sdf _gen_createSdf(float dist) {
	float matID = 2;
	Sdf res;
	res.x = dist;
	res.y = matID;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}

Sdf gen_blob(vec3 p, vec3 transform) {
	return _gen_createSdf(fBlob(p + transform));
}

Sdf gen_box(vec3 p, vec3 transform, vec3 scale){
	return _gen_createSdf(fBox(p + transform, scale));
}

Sdf gen_cylinder(vec3 p, vec3 transform, float radius, float height){
	return _gen_createSdf(fCylinder(p + transform, radius, height));
}

Sdf gen_capsule(vec3 p, vec3 transform, vec3 offsetA, vec3 offsetB, float radius) {
	return _gen_createSdf(fCapsule(p + transform, offsetA, offsetB, radius));
}

Sdf gen_cone(vec3 p, vec3 transform, float radius, float height) {
	return _gen_createSdf(fCone(p + transform, radius, height));
}

Sdf gen_fGDF(vec3 p, vec3 transform, float exponent, float radius, int begin, int end) {
	return _gen_createSdf(fGDF(p + transform, radius, exponent, begin, end));
}

Sdf gen_planeInfY(vec3 p, vec3 transform) {
	return _gen_createSdf((p + transform).y);
}
Sdf gen_roundBox(vec3 p, vec3 transform, vec3 scale, float radius) {
	vec3 d = abs(p + transform)-scale;
	return _gen_createSdf(length(max(d,0.))-radius);
}
Sdf gen_sphere(vec3 p, vec3 transform, float radius){
	float matID = 2;
	p += transform;
	return _gen_createSdf(length(p)-radius);
}
Sdf gen_torus(vec3 p, vec3 transform, vec2 rad){
	p += transform;
	return _gen_createSdf(fTorus(p + transform, rad.x, rad.y-0.1));
}

Sdf gen_quadFrameSmooth(vec3 p, vec3 transform, vec2 size, float radius, float smoothing) {
	return _gen_createSdf(fQuadFrameSmooth(p + transform, size, radius, smoothing));
}

Sdf gen_boxFrameSmooth(vec3 p, vec3 transform, vec3 size, float radius, float smoothing) {
	p += transform;
	// front quad frame
	float dist = fQuadFrameSmooth(
		p - vec3(0, 0, 0.5 * size.z),
		size.xy,
		radius, smoothing);
	// back quad frame
	dist = fOpUnionSoft(dist, fQuadFrameSmooth(
		p + vec3(0, 0, 0.5 * size.z),
		size.xy,
		radius, smoothing), smoothing);
	// top left front-back
	dist = fOpUnionSoft(dist, fCapsule(p,
		size * vec3(-0.5, 0.5, -0.5),
		size * vec3(-0.5, 0.5, 0.5),
		radius), smoothing);
	// top right front-back
	dist = fOpUnionSoft(dist, fCapsule(p,
		size * vec3(0.5, 0.5, -0.5),
		size * vec3(0.5, 0.5, 0.5),
		radius), smoothing);
	// bottom left front-back
	dist = fOpUnionSoft(dist, fCapsule(p,
		size * vec3(-0.5, -0.5, -0.5),
		size * vec3(-0.5, -0.5, 0.5),
		radius), smoothing);
	// bottom right front-back
	dist = fOpUnionSoft(dist, fCapsule(p,
		size * vec3(0.5, -0.5, -0.5),
		size * vec3(0.5, -0.5, 0.5),
		radius), smoothing);
	return _gen_createSdf(dist);
}

#endif // RTK_GENERATORS
