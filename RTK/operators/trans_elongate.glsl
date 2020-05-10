Sdf thismap(vec3 p, Context ctx) {
	vec3 h = THIS_Length;
	vec3 q = p - clamp(p, -h, h);
	return inputOp1(q, ctx);
}
