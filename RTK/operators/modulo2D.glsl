Sdf thismap(vec3 p, Context ctx) {
	vec2 q = p.PLANE + THIS_Shift;
	vec2 cell;
	switch (int(THIS_Mirrortype)) {
		case 1:
			cell = pModMirror2(q, THIS_Size);
			break;
		case 2:
			cell = pModGrid2(q, THIS_Size);
			break;
		default:
			cell = pMod2(q, THIS_Size);
			break;
	}
	p.PLANE = q - THIS_Offset;
	if (THIS_Instanceoncells > 0) {
		ctx.total = 4;
		ctx.iteration = quadrantIndex(ivec2(cell));
	}
	return inputOp1(p, ctx);
}
