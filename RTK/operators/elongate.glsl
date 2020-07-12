Sdf thismap(vec3 p, Context ctx) {
	return inputOp1(p - clamp(p, -THIS_Length, THIS_Length), ctx);
}
