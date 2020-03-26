Sdf thismap(vec3 p){
	return gen_quadFrameSmooth(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		vec2(@Scalex, @Scaley),
		@Radius, @Smoothing
	);
}
