Sdf thismap(vec3 p, Context ctx) {
	p = scaleRotateTranslate(
		p,
		vec3(@Translatex, @Translatey, @Translatez),
		radians(vec3(@Rotatex,@Rotatey, @Rotatez)),
		vec3(@Scalex, @Scaley, @Scalez),
		vec3(@Pivotx, @Pivoty, @Pivotz)
	);
	return inputOp1(p, ctx);
}
