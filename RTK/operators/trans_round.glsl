Sdf thismap(vec3 p){

	// p.x -= @Transformx;
	// p.y -= @Transformy;
	// p.z -= @Transformz;
	Sdf res;
	res = inputOp1(p);
	res.x -= @Round;
	return res;
	}
		


	
	