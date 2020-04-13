Sdf thismap__step(vec3 p, Context ctx, Sdf res1) {
	Sdf res2 = inputOp1(p, ctx);
	Sdf res;
BODY
;
	return res;
}
vec3 thismap__transform(vec3 p, Context ctx, int n) {
	vec3 t = texelFetch(thismap_instances, ctx.iteration).rgb;
	vec3 r = texelFetch(thismap_instances, ctx.iteration + n).rgb;
	vec3 s = texelFetch(thismap_instances, ctx.iteration + n * 2).rgb;
	vec3 pivot = texelFetch(thismap_instances, ctx.iteration + n * 3).rgb;
	return scaleRotateTranslate(p,
		t+vec3(0, 0, 0)*ctx.iteration,
		r+vec3(50,0,0)*ctx.iteration,
		vec3(1),//s,
		pivot + p
	);
}
Sdf thismap(vec3 p, Context ctx) {
	ctx.iteration = 0;
	int n = int(@Instancecount);
	Sdf res = inputOp1(thismap__transform(p, ctx, n), ctx);
	for (int i = 1; i < n; i++) {
		ctx.iteration = i;
		res = thismap__step(thismap__transform(p, ctx, n), ctx, res);
	}
	return res;
}