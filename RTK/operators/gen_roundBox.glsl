Sdf thismap(vec3 p){
	return gen_roundBox(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		vec3(@Scalex, @Scaley, @Scalez),
		@Radius
	);
}
