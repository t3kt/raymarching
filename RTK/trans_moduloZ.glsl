Sdf thismap(vec3 p) {
	p = trans_moduloZ(p, @Size);
	return inputOp1(p);
}
