Sdf thismap(vec3 p, Context ctx) {
	float a = float(ctx.iteration) / float(ctx.total - 1);
	vec3 s = mix(THIS_starts, THIS_ends, a);
	vec3 r = mix(THIS_startr, THIS_endr, a);
	vec3 t = mix(THIS_startt, THIS_endt, a);
	return inputOp1(scaleRotateTranslate(p, t, radians(r), s, THIS_Globalpivot), ctx);
}