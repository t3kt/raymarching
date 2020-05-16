Sdf thismap__step(vec3 p, Context ctx, Sdf res1) {
	Sdf res2 = inputOp1(p, ctx);
	Sdf res;
BODY();
	return res;
}
Sdf thismap(vec3 p, Context ctx) {
	ctx.iteration = 0;
	int n = int(THIS_Instancecount);
	ctx.total = n;
	Sdf res = inputOp1(p, ctx);
	for (int i = 1; i < n; i++) {
		ctx.iteration = i;
		res = thismap__step(p, ctx, res);
	}
	return res;
}