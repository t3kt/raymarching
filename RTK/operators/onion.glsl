Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	res.x = opOnion(res.x, THIS_Thickness);
	return res;
}
