Sdf thismap(vec3 p, Context ctx) {
	float a = float(ctx.iteration) / float(ctx.total - 1);
	vec3 s = mix(THIS_starts, THIS_ends, a);
	vec3 r = mix(THIS_startr, THIS_endr, a);
	vec3 t = mix(THIS_startt, THIS_endt, a);
	return inputOp1(scaleRotateTranslate(p, t, radians(r), s, THIS_Globalpivot), ctx);
//	mat3 start = mat3(
//		THIS_startm0,
//		THIS_startm1,
//		THIS_startm2
//	);
//	mat3 end = mat3(
//		THIS_endm0,
//		THIS_endm1,
//		THIS_end2
//	);
//	mat3 m = mat3(
//		mix(THIS_startm0, THIS_endm0, a),
//		mix(THIS_startm1, THIS_endm1, a),
//		mix(THIS_startm2, THIS_endm2, a)
//	);
//	p -= THIS_Globalpivot;
//	p *= m;
//	p += THIS_Globalpivot;
//	return inputOp1(p, ctx);
}