Sdf thismap(vec3 p, Context ctx) {
	int n = int(THIS_Instancecount);
	ctx.iteration = 0;
	ctx.total = n;
	Sdf res = inputOp1(p, ctx);
	for (int i = 1; i < n; i++) {
		ctx.iteration = i;
		res = comb_simpleUnion(res, inputOp1(p, ctx));
	}
	return res;
}