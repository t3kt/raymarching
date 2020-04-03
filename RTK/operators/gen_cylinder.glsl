Sdf thismap(vec3 p){
	return gen_cylinder(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		@Radius,
		@Height
	);
}
