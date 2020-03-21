Sdf thismap(vec3 p){
	Sdf res = inputOp1(p);
	res.x += sin(@Period*p.x+@Transformx)*sin(@Period*p.y+@Transformy)*sin(@Period*p.z+@Transformz)*@Scale1;
	res.x += sin(@Period*p.x*2+@Transformx)*sin(@Period*p.y*2+@Transformy)*sin(@Period*p.z*2+@Transformz)*@Scale2;
	res.x += sin(@Period*p.x*3+@Transformx)*sin(@Period*p.y*3+@Transformy)*sin(@Period*p.z*3+@Transformz)*@Scale3;
	return res;//inputOp1(p);
	}
		


	
	