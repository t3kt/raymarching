Sdf thismap(vec3 p){
	Sdf d1 = inputOp1(p);
	Sdf d2 = inputOp2(p);
	Sdf res = d1;
	float h = clamp(0.5 - 0.5*(d2.x+d1.x)/@Amount, 0., 1.);
	res.x = mix(d2.x, -d1.x, h) + @Amount*h*(1.0-h);
	// float d = opSmoothUnionM(res1.x , res2.x, @Amount );
	// float m = opSmoothUnion(res1.y , res2.y, @Amount );
	return res;//opSmoothUnionM(res1 , res2, @Amount );
	}
		


	
	
	