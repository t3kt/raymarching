Sdf thismap(vec3 p, Context ctx) {
BODY();
	p -= THIS_Offset;
	return inputOp1(p, ctx);
}