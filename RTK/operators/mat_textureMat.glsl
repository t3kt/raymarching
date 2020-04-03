Sdf thismap(vec3 p){
	int matID = @matID;
	Sdf res;
	res.x = inputOp1(p).x;
	res.y = matID;
	res.refract = false;
	res.reflect = false;
	return res;
	}
		


	
	