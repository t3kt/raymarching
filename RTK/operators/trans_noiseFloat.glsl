Sdf thismap(vec3 p, Context ctx) {
	float n = TDPerlinNoise(THIS_Period * p - -THIS_Transform-)*THIS_Scalex;
	Sdf res = inputOp1(p, ctx);
	res.x += n;
	return res;
}