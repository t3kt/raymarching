Sdf thismap(vec3 p){
	Sdf d1 = inputOp1(p);
	Sdf d2 = inputOp2(p);
	Sdf res = d1;
	res.x = max(-d1.x, d2.x);
	return res;//(d1.x>d2.x)? d1:d2;

	}
