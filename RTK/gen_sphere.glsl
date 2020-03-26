Sdf thismap(vec3 p){
	return gen_sphere(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		@Radius
	);
}
