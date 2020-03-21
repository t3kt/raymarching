Sdf thismap(vec3 p){
	p.x += sin(p.y*@Period+@Transformx)*@Scalex;
	p.y += sin(p.z*@Period+@Transformy)*@Scaley;
	p.z += sin(p.x*@Period+@Transformx)*@Scalez;

	return inputOp1(p);
	}
		


	
	