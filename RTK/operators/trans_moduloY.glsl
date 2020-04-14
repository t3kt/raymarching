Sdf thismap(vec3 p, Context ctx) {
	p = trans_moduloY(p, @Size);
	return inputOp1(p, ctx);
}
