Sdf thismap(vec3 p, Context ctx){
	float n = TDPerlinNoise(vec3(p.x*@Period+@Transformx, p.y*@Period+@Transformy,p.z*@Period+@Transformz))*(@Scalex);
	Sdf res = inputOp1(p, ctx);
	res.x += n;
	return res;
}