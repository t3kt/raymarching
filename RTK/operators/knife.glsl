Sdf thismap(vec3 p, Context ctx) {
	float plane = (p * rotateMatrix(radians(THIS_Rotateplane))).y - THIS_Offset;
	Sdf res = inputOp1(p, ctx);
	res.x = max(-plane * THIS_Side, res.x);
	return res;
}
