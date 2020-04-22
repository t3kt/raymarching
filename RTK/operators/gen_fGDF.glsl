Sdf thismap(vec3 p, Context ctx){
	return gen_fGDF(
		p,
		vec3(@Translatex, @Translatey, @Translatez),
		@E,
		@Radius,
		int(@Begin),
		int(@End),
		@Useexponent > 0.5
	);
}
