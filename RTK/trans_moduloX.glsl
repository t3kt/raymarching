Sdf thismap(vec3 p){
	float q = p.x;
	float halfsize = @Size*0.5;
	float c = floor((q + halfsize)/@Size);
	q = mod(q + halfsize, @Size) - halfsize;
	p.x  = q;
	return inputOp1(p);
	}
		


	
	