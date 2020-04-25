Sdf thismap(vec3 p, Context ctx) {
	vec3 t = texelFetch(thismap_instances, ctx.iteration).rgb;
	vec3 r = texelFetch(thismap_instances, ctx.iteration + n).rgb;
	vec3 s = texelFetch(thismap_instances, ctx.iteration + n * 2).rgb;
	vec3 pivot = texelFetch(thismap_instances, ctx.iteration + n * 3).rgb;
	p = scaleRotateTranslate(
		p,
		vec3(@Translatex, @Translatey, @Translatez),
		radians(vec3(@Rotatex,@Rotatey, @Rotatez)),
		vec3(1) / vec3(@Scalex, @Scaley, @Scalez),
		vec3(@Pivotx, @Pivoty, @Pivotz)
	);
	return inputOp1(p, ctx);
}