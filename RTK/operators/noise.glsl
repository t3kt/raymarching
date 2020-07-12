Sdf thismap(vec3 p, Context ctx) {
	p -= TDPerlinNoise(THIS_Period * p - THIS_Offset) * THIS_Scale;
	return inputOp1(p, ctx);
}
