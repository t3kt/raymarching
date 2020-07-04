Sdf thismap(vec3 p, Context ctx) {
	float value = FUNC(
		(p.AXIS / THIS_Period) + THIS_Phase);
	return inputOp1(p + (THIS_Amount * (value * THIS_Amplitude + THIS_Offset)), ctx);
}
