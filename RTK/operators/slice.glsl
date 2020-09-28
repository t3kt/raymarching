Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	float d = abs(p.AXIS - THIS_Offset) - THIS_Thickness;
	#ifdef THIS_USE_SMOOTHING
	res.x = fOpIntersectionRound(res.x, d, THIS_Smoothradius);
	#else
	res.x = max(res.x, d);
	#endif
	return res;
}
