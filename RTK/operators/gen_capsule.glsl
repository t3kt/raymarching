Sdf thismap(vec3 p, Context ctx){
	return gen_capsule(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		vec3(@Offset1x, @Offset1y, @Offset1z),
		vec3(@Offset2x, @Offset2y, @Offset2z),
		@Radius
	);
}
