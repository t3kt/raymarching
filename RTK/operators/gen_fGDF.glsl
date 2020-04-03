Sdf thismap(vec3 p){
	return gen_fGDF(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		@E,
		@Radius,
		int(@Begin),
		int(@End)
	);
}
