Sdf thismap(vec3 p){
	p = trans_textureNoise(
		p,
		int(@Texindex),
		@Period,
		vec3(@Scalex, @Scaley, @Scalez)
	);
	return inputOp1(p);
	}
		


	
	