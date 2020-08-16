vec4 thismap(vec3 p, Context ctx) {
	vec4 val = inputOp1(p, ctx);
	val = mapRange(val, THIS_Fromlow, THIS_Fromhigh, THIS_Tolow, THIS_Tohigh);
	if (THIS_Clamp > 0) {
		return clamp(val, THIS_Tolow, THIS_Tohigh);
	}
	return val;
}
