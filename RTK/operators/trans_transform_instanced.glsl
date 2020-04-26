Sdf thismap(vec3 p, Context ctx) {
	int n = int(@Instancecount);
	vec3 t = texelFetch(thismap_instances, ctx.iteration).rgb;
	vec3 r = texelFetch(thismap_instances, ctx.iteration + n).rgb;
	vec3 s = texelFetch(thismap_instances, ctx.iteration + n * 2).rgb;
	vec3 pivot = texelFetch(thismap_instances, ctx.iteration + n * 3).rgb;
	p = scaleRotateTranslate(
		p,
		t,
		radians(r),
		vec3(1) / s,
		pivot
	);
	return inputOp1(p, ctx);
}