float thismap(vec3 p, Context ctx) {
	#ifdef THIS_INPUT_TYPE_scalar
	float val = inputOp1(p, ctx);
	#endif
	#ifdef THIS_INPUT_TYPE_field
	float val = inputOp1(p, ctx).AXIS;
	#endif
	#ifdef THIS_INPUT_TYPE_sdf
	float val = inputOp1(p, ctx).x;
	#endif
	#ifdef THIS_INPUT_TYPE_sdf2d
	float val = inputOp1(p.PLANE, ctx).x;
	#endif
	return THIS_Offset + THIS_Amplitude * THIS_FUNC(val / THIS_Period + THIS_Phase);
}
