#ifndef RTK_GENERATORS
#define RTK_GENERATORS

Sdf gen_blob(vec3 p, vec3 transform) {
	p += transform;
	Sdf res;
	res.x = fBlob(p);
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}

Sdf gen_box(vec3 p, vec3 transform, vec3 scale){
	p += transform;
	Sdf res;
	res.x = fBox(p, scale);
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}

Sdf gen_cylinder(vec3 p, vec3 transform, float radius, float height){
	p += transform;
	Sdf res;
	res.x = fCylinder(p, radius, height);
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
Sdf gen_fGDF(vec3 p, vec3 transform, float exponent, float radius, int begin, int end){
	p += transform;
	float d = fGDF(p, radius, exponent, begin, end);
	Sdf res;
	res.x = d;
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}

Sdf gen_planeInfY(vec3 p, vec3 transform){
	p += transform;
	Sdf res;
	res.x = p.y;
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
Sdf gen_roundBox(vec3 p, vec3 transform, vec3 scale, float radius){
	p += transform;
	vec3 b = scale;
	vec3 d = abs(p)-b;
	Sdf res;
	res.x = length(max(d,0.))-radius;
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
Sdf gen_sphere(vec3 p, vec3 transform, float radius){
	float matID = 2;
	p += transform;
	Sdf res;
	res.x = length(p)-radius;
	res.y = matID;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
Sdf gen_torus(vec3 p, vec3 transform, vec2 rad){
	p += transform;
	Sdf res;
	res.x = fTorus(p, rad.x, rad.y-0.1);
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}

#endif // RTK_GENERATORS
