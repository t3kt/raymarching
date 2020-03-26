Sdf thismap(vec3 p) {
	p = trans_sine(p, @Period, vec3(@Transformx, @Transformy, @Transformz), vec3(@Scalex, @Scaley, @Scalez));
	return inputOp1(p);
}
