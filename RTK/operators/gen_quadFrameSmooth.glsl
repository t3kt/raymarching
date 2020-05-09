Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fQuadFrameSmooth(
		p - vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz),
		vec2(THIS_Scalex, THIS_Scaley),
		THIS_Radius, THIS_Smoothing));
}
