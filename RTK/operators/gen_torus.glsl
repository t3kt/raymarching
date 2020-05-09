Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fTorus(
		p - vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz),
		THIS_Rad1, THIS_Rad2-0.1));
}
