Sdf thismap(vec3 p) {
	p = trans_reflect(p, vec3(@Normalx, @Normaly, @Normalz), @Offset);
	return inputOp1(p);
}
