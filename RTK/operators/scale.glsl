Sdf thismap(THIS_COORD_TYPE p, Context ctx) {
	Sdf res = inputOp1(p / THIS_Scale, ctx);
	res.x /= length(THIS_Scale);
	return res;
}
