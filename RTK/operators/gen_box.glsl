Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fBox(
		p - vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz),
		vec3(THIS_Scalex, THIS_Scaley, THIS_Scalez)));
}
