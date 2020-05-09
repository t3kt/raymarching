Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fCapsule(
		p - vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz),
		vec3(THIS_End1x, THIS_End1y, THIS_End1z),
		vec3(THIS_End2x, THIS_End2y, THIS_End2z),
		THIS_Radius));
}
