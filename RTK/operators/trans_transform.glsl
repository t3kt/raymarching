Sdf thismap(vec3 p) {
	p = scaleRotateTranslate(
		p,
		vec3(@Scalex, @Scaley, @Scalez),
		radians(vec3(@Rotatex,@Rotatey, @Rotatez)),
		vec3(@Translatex, @Translatey, @Translatez),
		vec3(@Pivotx, @Pivoty, @Pivotz)
	);
	return inputOp1(p);
}
