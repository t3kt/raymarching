Sdf thismap(vec3 p, Context ctx) {
	p -= THIS_Center;
	float amount = smoothstep(0, THIS_Fade, inputOp2(p - THIS_Center, ctx) - THIS_Radius);
	p *= rotateMatrix(radians(mix(THIS_Rotate * THIS_Amount, vec3(0), amount)));
	vec3 scale = mix(vec3(1), mix(THIS_Scale, vec3(1), amount), THIS_Amount);
	Sdf res = inputOp1((p / scale) + THIS_Center, ctx);
	res.x /= length(scale);
	return res;
}