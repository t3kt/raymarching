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

Sdf gen_fGDF(vec3 p, vec3 transform, float exponent, float radius, int begin, int end, bool useExponent) {
	if (useExponent) {
		return createSdf(fGDF(p + transform, radius, exponent, begin, end));
	} else {
		return createSdf(fGDF(p + transform, radius, begin, end));
	}
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

Sdf gen_disc(vec3 p, vec3 translate, float radius) {
	p += translate;
	return createSdf(fDisc(p, radius));
}

Sdf gen_mandelbulb(vec3 p, vec3 translate)
{
	p += translate;
	vec3 w = p;
	float m = dot(w, w);

	vec4 trap = vec4(abs(w), m);
	float dz = 1.0;


	for (int i=0; i<4; i++)
	{
		#if 0
		float m2 = m*m;
		float m4 = m2*m2;
		dz = 8.0*sqrt(m4*m2*m)*dz + 1.0;

		float x = w.x; float x2 = x*x; float x4 = x2*x2;
		float y = w.y; float y2 = y*y; float y4 = y2*y2;
		float z = w.z; float z2 = z*z; float z4 = z2*z2;

		float k3 = x2 + z2;
		float k2 = inversesqrt(k3*k3*k3*k3*k3*k3*k3);
		float k1 = x4 + y4 + z4 - 6.0*y2*z2 - 6.0*x2*y2 + 2.0*z2*x2;
		float k4 = x2 - y2 + z2;

		w.x = p.x +  64.0*x*y*z*(x2-z2)*k4*(x4-6.0*x2*z2+z4)*k1*k2;
		w.y = p.y + -16.0*y2*k3*k4*k4 + k1*k1;
		w.z = p.z +  -8.0*y*k4*(x4*x4 - 28.0*x4*x2*z2 + 70.0*x4*z4 - 28.0*x2*z2*z4 + z4*z4)*k1*k2;
		#else
		dz = 8.0*pow(sqrt(m), 7.0)*dz + 1.0;
		//dz = 8.0*pow(m,3.5)*dz + 1.0;

		float r = length(w);
		float b = 8.0*acos(w.y/r);
		float a = 8.0*atan(w.x, w.z);
		w = p + pow(r, 8.0) * vec3(sin(b)*sin(a), cos(b), sin(b)*cos(a));
		#endif

		trap = min(trap, vec4(abs(w), m));

		m = dot(w, w);
		if (m > 256.0)
		break;
	}

//	resColor = vec4(m, trap.yzw);

	return createSdf(0.25*log(m)*sqrt(m)/dz);
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
