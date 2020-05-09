Sdf thismap(vec3 p, Context ctx) {
	p += texture(THIS_texture, (p.xz)*THIS_Period).rgb*vec3(THIS_Scalex, THIS_Scaley, THIS_Scalez);
	return inputOp1(p, ctx);
}
