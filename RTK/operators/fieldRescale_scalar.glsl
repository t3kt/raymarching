float thismap(vec3 p, Context ctx) {
	float val = inputOp1(p, ctx);
	val = mapRange(val, THIS_Fromlowx, THIS_Fromhighx, THIS_Tolowx, THIS_Tohighx);
	if (THIS_Clamp > 0) {
		return clamp(val, THIS_Tolowx, THIS_Tohighx);
	}
	return val;
}
