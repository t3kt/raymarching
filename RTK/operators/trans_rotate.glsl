Sdf thismap(vec3 p, Context ctx) {
	mat3 m = TDRotateOnAxis(THIS_Amount,  normalize(THIS_Axis));
	p *= m;
	return inputOp1(p, ctx);
}
