Sdf thismap(vec3 p, Context ctx) {
	pReflect(p, vec3(THIS_Normalx, THIS_Normaly, THIS_Normalz), THIS_Offset);
	return inputOp1(p, ctx);
}
