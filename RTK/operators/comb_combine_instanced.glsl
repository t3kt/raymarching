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
//	vec3 t = texelFetch(thismap_instances_t, ctx.iteration).rgb;
//	vec3 r = texelFetch(thismap_instances_r, ctx.iteration).rgb;
//	vec3 s = texelFetch(thismap_instances_s, ctx.iteration).rgb;
//	vec3 pivot = texelFetch(thismap_instances_p, ctx.iteration).rgb;
	
//	t *= 0;
//	t+=vec3(0.4, 0, 0)*ctx.iteration;
	//r *= 0;
	//+vec3(50,0,0)*ctx.iteration)
//	s = vec3(1);
	return scaleRotateTranslate(p,
		t,
		radians(r),
		1/s,
		pivot
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