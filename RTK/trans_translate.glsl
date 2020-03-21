Sdf thismap(vec3 p){
	p.x -= @Transformx;
	p.y -= @Transformy;
	p.z -= @Transformz;
	return inputOp1(p);
	}
		


	
	