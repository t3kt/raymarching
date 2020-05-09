Sdf thismap(vec3 p, Context ctx) {
	vec3 pivot = vec3(THIS_Globalpivotx, THIS_Globalpivoty, THIS_Globalpivotz);
	float a = float(ctx.iteration) / float(ctx.total - 1);
	vec3 s = mix(
		vec3(THIS_startsx, THIS_startsy, THIS_startsz),
		vec3(THIS_endsx, THIS_endsy, THIS_endsz),
		a);
	vec3 r = mix(
		vec3(THIS_startrx, THIS_startry, THIS_startrz),
		vec3(THIS_endrx, THIS_endry, THIS_endrz),
		a);
	vec3 t = mix(
		vec3(THIS_starttx, THIS_startty, THIS_starttz),
		vec3(THIS_endtx, THIS_endty, THIS_endtz),
		a);
	return inputOp1(scaleRotateTranslate(p, t, radians(r), s, pivot), ctx);
}