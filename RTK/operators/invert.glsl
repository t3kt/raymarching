Sdf thismap(COORD p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	res.x *= -1;
	return res;
}
