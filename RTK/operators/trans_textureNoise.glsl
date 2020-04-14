Sdf thismap(vec3 p, Context ctx) {
	p = trans_textureNoise(
		p,
		int(@Texindex),
		@Period,
		vec3(@Scalex, @Scaley, @Scalez)
	);
	return inputOp1(p, ctx);
}
