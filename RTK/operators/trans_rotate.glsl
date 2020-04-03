Sdf thismap(vec3 p) {
	p = trans_rotate(p, @Amount,  vec3(@Axisx, @Axisy, @Axisz));
	return inputOp1(p);
}
