Sdf thismap(vec3 p, Context ctx) {
	float ratio = map01(p.AXIS, THIS_Offset1, THIS_Offset2);
	if (ratio < 0 && THIS_Clamp1 > 0) {
		ratio = 0;
	} else if (ratio > 1 && THIS_Clamp2 > 0) {
		ratio = 1;
	}
	ratio = INTERPOLATION(ratio);
	vec2 pivot = mix(THIS_Pivot1, THIS_Pivot2, ratio);
	vec2 scale = mix(THIS_Scale1, THIS_Scale2, ratio);
	vec2 q = (p.PLANE + pivot);
	q /= scale;
	q -= pivot;
	p.PLANE = q;
	Sdf res = inputOp1(p, ctx);
	res.x /= length(scale);
	return res;
}
