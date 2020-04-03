#ifndef RTK_GENERATORS
#define RTK_GENERATORS

Sdf gen_blob(vec3 p, vec3 transform) {
	return createSdf(fBlob(p + transform));
}

Sdf gen_box(vec3 p, vec3 transform, vec3 scale){
	return createSdf(fBox(p + transform, scale));
}

Sdf gen_cylinder(vec3 p, vec3 transform, float radius, float height){
	return createSdf(fCylinder(p + transform, radius, height));
}

Sdf gen_capsule(vec3 p, vec3 transform, vec3 offsetA, vec3 offsetB, float radius) {
	return createSdf(fCapsule(p + transform, offsetA, offsetB, radius));
}

Sdf gen_cone(vec3 p, vec3 transform, float radius, float height) {
	return createSdf(fCone(p + transform, radius, height));
}

Sdf gen_fGDF(vec3 p, vec3 transform, float exponent, float radius, int begin, int end) {
	return createSdf(fGDF(p + transform, radius, exponent, begin, end));
}

Sdf gen_planeInfY(vec3 p, vec3 transform) {
	return createSdf((p + transform).y);
}
Sdf gen_roundBox(vec3 p, vec3 transform, vec3 scale, float radius) {
	vec3 d = abs(p + transform)-scale;
	return createSdf(length(max(d,0.))-radius);
}
Sdf gen_sphere(vec3 p, vec3 transform, float radius){
	float matID = 2;
	p += transform;
	return createSdf(length(p)-radius);
}
Sdf gen_torus(vec3 p, vec3 transform, vec2 rad){
	p += transform;
	return createSdf(fTorus(p + transform, rad.x, rad.y-0.1));
}

Sdf gen_quadFrameSmooth(vec3 p, vec3 transform, vec2 size, float radius, float smoothing) {
	return createSdf(fQuadFrameSmooth(p + transform, size, radius, smoothing));
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
	return createSdf(dist);
}

#endif // RTK_GENERATORS
