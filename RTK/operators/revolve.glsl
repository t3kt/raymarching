Sdf thismap(vec3 p, Context ctx) {
	vec2 q = vec2(length(p.PLANE - THIS_Translate.PLANE) - THIS_Offset, p.AXIS - THIS_Translate.AXIS);
	return inputOp1(q, ctx);
}
