Sdf thismap(vec3 p){
	return gen_boxFrameSmooth(
		p,
		vec3(@Transformx, @Transformy, @Transformz),
		vec3(@Scalex, @Scaley, @Scalez),
		@Radius, @Smoothing
	);
}
