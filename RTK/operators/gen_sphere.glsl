Sdf thismap(vec3 p, Context ctx){
	return gen_sphere(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		@Radius
	);
}
