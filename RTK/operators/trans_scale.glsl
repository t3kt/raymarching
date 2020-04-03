Sdf thismap(vec3 p){
	// Not sure this is correct
	vec3 scaleVec = vec3(@Scalex, @Scaley, @Scalez);
	p *= scaleVec;
	Sdf res = inputOp1(p);
	res.x /=length(scaleVec);
	return res;
	}
		


	
	