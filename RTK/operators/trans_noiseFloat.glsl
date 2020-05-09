Sdf thismap(vec3 p, Context ctx) {
	float n = TDPerlinNoise(
		THIS_Period * p + vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz))*THIS_Scalex;
	Sdf res = inputOp1(p, ctx);
	res.x += n;
	return res;
}