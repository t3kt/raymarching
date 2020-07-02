Sdf thismap(vec3 p, Context ctx) {
	mat3 r = TDRotateOnAxis(radians(THIS_Rotateaxis), AXISVEC);
	p *= r;
	vec2 offset = THIS_Offset.PLANE;
	vec2 temp = p.PLANE + offset;
	vec2 cell = pMirrorOctant(temp, THIS_Size.PLANE);
	if (THIS_Instanceoncells > 0) {
		/*
		[0] -1, 1    [1] 1, 1
		[2] -1, -1   [3] 1, -1
		*/
		ctx.total = 4;
		ivec2 cellI = ivec2((cell + 1) / 2);
		ctx.iteration = (cellI.y * 2) + cellI.x;
	}
	p.PLANE = temp - offset;
	p *= -r;
	return inputOp1(p, ctx);
}