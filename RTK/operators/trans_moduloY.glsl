Sdf thismap(vec3 p) {
	p = trans_moduloY(p, @Size);
	return inputOp1(p);
}
