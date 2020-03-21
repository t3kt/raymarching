Sdf thismap(vec3 p){
	int matID = @matID;
	Sdf res;
	res.x = inputOp1(p).x;
	res.y = matID;
	res.refract = true;
	res.reflect = true;
	res.ior = @Ior;
	return res;
	}
		


	
	