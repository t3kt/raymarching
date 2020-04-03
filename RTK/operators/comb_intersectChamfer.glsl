Sdf thismap(vec3 p){
	Sdf res1 = inputOp1(p);
	Sdf res2 = inputOp2(p);
	return comb_intersectChamfer(p, res1, res2, @Radius);
}
