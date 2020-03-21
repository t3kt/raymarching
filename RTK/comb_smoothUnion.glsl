Sdf thismap(vec3 p){
	Sdf res1 = inputOp1(p);
	Sdf res2 = inputOp2(p);
	// float d = opSmoothUnionM(res1.x , res2.x, @Amount );
	// float m = opSmoothUnion(res1.y , res2.y, @Amount );
	return opSmoothUnionM(res1 , res2, @Amount );
	}
		


	
	
	