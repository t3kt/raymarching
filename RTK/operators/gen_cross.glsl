Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdCross(
		p + vec3(THIS_Translatex, THIS_Translatey, THIS_Translatez),
		vec3(THIS_Sizex, THIS_Sizey, THIS_Sizez)
	));
}
