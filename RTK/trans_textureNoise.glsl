Sdf thismap(vec3 p){
	p += texture(sTD2DInputs[int(@Texindex)], (p.xz)*@Period).rgb*vec3(@Scalex, @Scaley, @Scalez);//TDPerlinNoise(vec3(p.x*@Period+@Transformx, p.y*@Period+@Transformy,p.z*@Period+@Transformz))*vec3(@Scalex, @Scaley, @Scalez);
	return inputOp1(p);
	}
		


	
	