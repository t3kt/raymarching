Sdf thismap(THIS_COORD_TYPE p, Context ctx) {
	float q = p.AXIS + THIS_Shift;
	float cell = THIS_Mirrortype > 0 ? pModMirror1(q, THIS_Size) : pMod1(q, THIS_Size);
	p.AXIS = q - THIS_Offset;
	if (THIS_Instanceoncells > 0) {
		ctx.total = 2;
		ctx.iteration = int(clamp(cell, 0, 1));
	}
	return inputOp1(p, ctx);
}
