Sdf thismap(vec3 p) {
	vec3 q = trans_elongate(p, vec3(@Lengthx, @Lengthy,@Lengthz));
	return inputOp1(q);
}
