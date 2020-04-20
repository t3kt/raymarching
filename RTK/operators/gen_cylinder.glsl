Sdf thismap(vec3 p, Context ctx){
	return gen_cylinder(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		@Radius,
		@Height
	);
}
