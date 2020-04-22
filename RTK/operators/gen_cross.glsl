Sdf thismap(vec3 p, Context ctx){
	return createSdf(sdCross(
		p + vec3(@Translatex, @Translatey, @Translatez),
		vec3(@Sizex, @Sizey, @Sizez)
	));
}
