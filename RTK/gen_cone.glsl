Sdf thismap(vec3 p){
	return gen_cone(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		@Radius, @Height
	);
}
