Sdf thismap(vec3 p, Context ctx){
	return gen_disc(
		p,
		vec3(@Translatex, @Translatey, @Translatez),
		@Radius
	);
}
