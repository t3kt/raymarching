Sdf thismap(vec3 p, Context ctx) {
	vec3 h = vec3(THIS_Lengthx, THIS_Lengthy,THIS_Lengthz);
	vec3 q = p - clamp(p, -h, h);
	return inputOp1(q, ctx);
}
