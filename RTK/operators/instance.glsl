Sdf thismap(vec3 p, Context ctx) {
	ctx.iteration = 0;
	int n = int(@Instancecount);
	Sdf res = inputOp1(p, ctx);
	for (int i = 1; i < n; i++) {
		ctx.iteration = i;
		res = comb_simpleUnion(p, res, inputOp1(p, ctx));
	}
	return res;
}