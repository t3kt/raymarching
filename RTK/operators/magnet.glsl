Sdf thismap(vec3 p, Context ctx) {
	p -= THIS_Center;
	#ifdef THIS_USE_INPUT_FIELD
	float val = inputOp2(p - THIS_Center, ctx);
	#else
	float val = length(p);
	#endif
	float amount = smoothstep(0, THIS_Fade, val - THIS_Radius);
	p *= rotateMatrix(radians(mix(THIS_Rotate * THIS_Amount, vec3(0), amount)));
	vec3 scale = mix(vec3(1), mix(THIS_Scale, vec3(1), amount), THIS_Amount);
	Sdf res = inputOp1((p / scale) + THIS_Center, ctx);
	res.x /= length(scale);
	return res;
}