Sdf thismap(vec3 p){
	Sdf res1 = inputOp1(p);
	Sdf res2 = inputOp2(p);
	float d = fOpDifferenceRound (res1.x, res2.x, @Radius);
	res1.x = d;
	return res1;
	}




