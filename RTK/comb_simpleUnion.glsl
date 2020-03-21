Sdf thismap(vec3 p){
	Sdf d1 = inputOp1(p);
	Sdf d2 = inputOp2(p);
	return (d1.x<d2.x)? d1:d2;

	}
