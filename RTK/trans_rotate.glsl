Sdf thismap(vec3 p){
	mat3 m = TDRotateOnAxis(@Amount, vec3(@Axisx, @Axisy, @Axisz));
	p *= m;
	return inputOp1(p);
	}
		


	
	