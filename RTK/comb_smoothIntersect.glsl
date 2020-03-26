Sdf thismap(vec3 p){
	Sdf d1 = inputOp1(p);
	Sdf d2 = inputOp2(p);
	return comb_smoothIntersect(p, d1, d2, @Amount);
}
