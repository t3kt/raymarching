Sdf thismap(vec3 p, Context ctx){
	// int matID = @matID;
	Sdf s = inputOp1(p, ctx);
	s.y = 1;
	return s;
}
