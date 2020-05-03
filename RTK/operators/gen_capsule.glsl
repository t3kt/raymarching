Sdf thismap(vec3 p, Context ctx){
	return gen_capsule(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		vec3(@End1x, @End1y, @End1z),
		vec3(@End2x, @End2y, @End2z),
		@Radius
	);
}
