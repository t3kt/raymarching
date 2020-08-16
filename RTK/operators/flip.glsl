Sdf thismap(vec3 p, Context ctx) {
	vec3 q = p;
	q.AXIS += THIS_Offset;
	q.AXIS *= -1;
	q.AXIS -= THIS_Shift;
	return inputOp1(q, ctx);
}
