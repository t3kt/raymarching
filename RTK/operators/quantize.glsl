Sdf thismap(vec3 p, Context ctx) {
	p = trans_quantizeXYZ(p, THIS_Size, THIS_Offset, THIS_Smooth);
	return inputOp1(p, ctx);
}
