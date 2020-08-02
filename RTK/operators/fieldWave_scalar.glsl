Sdf thismap(vec3 p, Context ctx) {
	float val = inputOp1(p, ctx);
	return THIS_Offset + THIS_Amplitude * FUNC(val / THIS_Period + THIS_Phase);
}
