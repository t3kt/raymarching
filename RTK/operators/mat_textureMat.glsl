Sdf thismap(vec3 p, Context ctx){
	int matID = @matID;
	Sdf res;
	res.x = inputOp1(p, ctx).x;
	res.y = matID;
	res.refract = false;
	res.reflect = false;
	return res;
}
