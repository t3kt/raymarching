Sdf thismap(vec3 p, Context ctx) {
	p = scaleRotateTranslate(
		p,
		vec3(THIS_Translatex, THIS_Translatey, THIS_Translatez),
		radians(vec3(THIS_Rotatex,THIS_Rotatey, THIS_Rotatez)),
		vec3(THIS_Scalex, THIS_Scaley, THIS_Scalez),
		vec3(THIS_Pivotx, THIS_Pivoty, THIS_Pivotz)
	);
	return inputOp1(p, ctx);
}
