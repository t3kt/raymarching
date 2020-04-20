Sdf thismap(vec3 p, Context ctx){
	return gen_cone(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		@Radius, @Height
	);
}
