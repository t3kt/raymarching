Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p.PLANE, ctx);
	vec2 w = vec2(res.x, abs(p.AXIS - THIS_Offset) - THIS_Height);
	res.x = min(max(w.x,w.y), 0.0) + length(max(w, 0.0));
	return res;
}
