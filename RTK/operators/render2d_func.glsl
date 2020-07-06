Sdf thismap(vec2 p){
	return inputOp1(p, defaultContext());
}
Sdf thismap(vec2 p, Context ctx){
	Sdf res = inputOp1(p, ctx);
	res.y = @matID;
	return res;
}
		


	
	