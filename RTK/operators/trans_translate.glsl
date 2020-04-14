Sdf thismap(vec3 p, Context ctx) {
	p = trans_translate(p, vec3(@Transformx, @Transformy, @Transformz));
	return inputOp1(p, ctx);
}
