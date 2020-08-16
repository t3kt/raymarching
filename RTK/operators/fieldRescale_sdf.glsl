Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	res.x = mapRange(res.x, THIS_Fromlow, THIS_Fromhigh, THIS_Tolow, THIS_Tohigh);
	if (THIS_Clamp > 0) {
		res.x = clamp(res.x, THIS_Tolow, THIS_Tohigh);
	}
	return res;
}
