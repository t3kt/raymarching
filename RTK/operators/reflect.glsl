Sdf thismap(vec3 p, Context ctx) {
	pReflect(p, THIS_Normal, THIS_Offset);
	return inputOp1(p, ctx);
}
