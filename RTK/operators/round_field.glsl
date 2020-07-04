Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	res.x -= THIS_Round;
	if (THIS_Fieldlevel != 0) {
		res.x += inputOp2(p, ctx) * THIS_Fieldlevel;
	}
	return res;
}
