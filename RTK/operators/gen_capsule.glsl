Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fCapsule(p - THIS_Transform, THIS_End1, THIS_End2, THIS_Radius));
}
