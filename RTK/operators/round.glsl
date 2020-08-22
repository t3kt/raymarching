Sdf thismap(THIS_COORD_TYPE p, Context ctx) {
	Sdf res;
	res = inputOp1(p, ctx);
	res.x -= THIS_Round;
	return res;
}
