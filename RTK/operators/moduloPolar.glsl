Sdf thismap(vec3 p, Context ctx) {
	vec3 offset = THIS_Offset;
	mat3 r = TDRotateOnAxis(radians(THIS_Angleoffset), AXISVEC);
	p = (p + offset) * -r;
	vec2 q = p.PLANE;
	pModPolar(q, THIS_Repetitions);
	p.PLANE = q;
	return inputOp1((p * r) - offset, ctx);
}