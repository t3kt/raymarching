Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	#ifdef THIS_USE_MIRROR
	float q = abs(p.AXIS);
	#else
	float q = p.AXIS;
	#endif
	float d = abs(q - THIS_Offset) - THIS_Thickness;
	#ifdef THIS_USE_SMOOTHING
	res.x = fOpIntersectionRound(res.x, d, THIS_Smoothradius);
	#else
	res.x = max(res.x, d);
	#endif
	return res;
}
