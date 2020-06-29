Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdRhombus(
		p - THIS_Translate,
		THIS_Length1, THIS_Length2, THIS_Height, THIS_Corner));
}
