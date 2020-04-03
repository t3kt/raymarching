Sdf thismap(vec3 p) {
	p = trans_moduloX(p, @Size);
	return inputOp1(p);
}
