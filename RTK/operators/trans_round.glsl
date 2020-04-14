Sdf thismap(vec3 p, Context ctx){
	// p.x -= @Transformx;
	// p.y -= @Transformy;
	// p.z -= @Transformz;
	Sdf res;
	res = inputOp1(p, ctx);
	res.x -= @Round;
	return res;
}
