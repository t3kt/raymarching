Sdf thismap(vec3 p, Context ctx) {
	Sdf res1 = inputOp1(p, ctx);
	Sdf res2 = inputOp2(p, ctx);
	float h = THIS_Blend;
	if (h < 0.5) {
		res1.x = mix(res1.x, res2.x, h);
		res1.material2 = res2.y;
		res1.interpolant = h;
		return res1;
	} else {
		res2.x = mix(res1.x, res2.x, h);
		res2.material2 = res1.y;
		res2.interpolant = 1.0 - h;
		return res2;
	}
}