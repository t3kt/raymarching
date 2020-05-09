Sdf thismap(vec3 p, Context ctx) {
	mat3 m = TDRotateOnAxis(THIS_Amount,  normalize(vec3(THIS_Axisx, THIS_Axisy, THIS_Axisz)));
	p *= m;
	return inputOp1(p, ctx);
}
