Sdf thismap(vec3 p, Context ctx) {
	p = trans_reflect(p, vec3(@Normalx, @Normaly, @Normalz), @Offset);
	return inputOp1(p, ctx);
}
