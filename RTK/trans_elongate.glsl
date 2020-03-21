Sdf thismap(vec3 p){
	vec3 h = vec3(@Lengthx, @Lengthy,@Lengthz);
	vec3 q = p - clamp(p, -h, h);
	return inputOp1(q);
	}
		


	
	