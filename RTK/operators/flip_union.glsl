Sdf thismap(vec3 p, Context ctx) {
	vec3 q = p;
	q.AXIS += THIS_Offset;
	q.AXIS *= -1;
	q.AXIS -= THIS_Shift;
	p.AXIS += THIS_Offset;
	p.AXIS -= THIS_Shift;
	return comb_simpleUnion(inputOp1(p, ctx), inputOp1(q, ctx));
}
