Sdf thismap(vec3 p){
	p += TDPerlinNoise(vec3(p.x*@Period+@Transformx, p.y*@Period+@Transformy,p.z*@Period+@Transformz))*vec3(@Scalex, @Scaley, @Scalez);
	return inputOp1(p);
	}
		


	
	