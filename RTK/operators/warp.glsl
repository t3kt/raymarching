Sdf thismap(vec3 p, Context ctx) {
	vec3 field = inputOp2(p, ctx).xyz;
	p += THIS_Uniformscale * (field * THIS_Scale + THIS_Offset);
	return inputOp1(p, ctx);
}