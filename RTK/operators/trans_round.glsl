Sdf thismap(vec3 p, Context ctx) {
	Sdf res;
	res = inputOp1(p, ctx);
	res.x -= THIS_Round;
	return res;
}
