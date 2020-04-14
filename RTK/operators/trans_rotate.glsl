Sdf thismap(vec3 p, Context ctx) {
	p = trans_rotate(p, @Amount,  vec3(@Axisx, @Axisy, @Axisz));
	return inputOp1(p, ctx);
}
