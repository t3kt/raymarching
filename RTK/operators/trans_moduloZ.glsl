Sdf thismap(vec3 p, Context ctx) {
	p = trans_moduloZ(p, @Size);
	return inputOp1(p, ctx);
}
