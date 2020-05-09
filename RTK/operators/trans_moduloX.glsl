Sdf thismap(vec3 p, Context ctx) {
	p = trans_moduloX(p, THIS_Size);
	return inputOp1(p, ctx);
}
