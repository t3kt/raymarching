Sdf thismap(vec3 p){
	Sdf res1 = inputOp1(p);
	Sdf res2 = inputOp2(p);
	float d = fOpDifferenceColumns(res1.x, res2.x, @Radius, @Num);
	res1.x = d;
	return res1;
	}
		


	
	
	