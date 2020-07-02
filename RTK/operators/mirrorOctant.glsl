Sdf thismap(vec3 p, Context ctx) {
	mat3 r = TDRotateOnAxis(radians(THIS_Rotateaxis), AXISVEC);
	p *= r;
	vec2 offset = THIS_Offset.PLANE;
	vec2 temp = p.PLANE + offset;
	vec2 cell = pMirrorOctant(temp, THIS_Size.PLANE);
	if (THIS_Instanceoncells > 0) {
		ctx.total = 4;
		ctx.iteration = quadrantIndex(ivec2(cell));
	}
	p.PLANE = temp - offset;
	p *= -r;
	return inputOp1(p, ctx);
}