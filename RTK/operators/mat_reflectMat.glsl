Sdf thismap(vec3 p, Context ctx) {
	int matID = @matID;
	Sdf res;
	res.x = inputOp1(p, ctx).x;
	res.y = matID;
	res.refract = true;
	res.reflect = true;
	res.ior = @Ior;
	return res;
}
