Sdf thismap(vec3 p, Context ctx) {
	p -= texture(THIS_texture, (p.xz)*THIS_Period).rgb*THIS_Scale;
	return inputOp1(p, ctx);
}
