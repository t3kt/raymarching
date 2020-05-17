Sdf thismap(vec3 p, Context ctx) {
	int n = int(THIS_Instancecount);
	return inputOp1(scaleRotateTranslate(
		p,
		texelFetch(thismap_instances, ctx.iteration).rgb,
		radians(texelFetch(thismap_instances, ctx.iteration + n).rgb),
		vec3(1) / texelFetch(thismap_instances, ctx.iteration + n * 2).rgb,
		texelFetch(thismap_instances, ctx.iteration + n * 3).rgb
	), ctx);
}