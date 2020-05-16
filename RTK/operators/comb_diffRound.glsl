Sdf thismap(vec3 p, Context ctx){
	Sdf res1 = inputOp1(p, ctx);
	Sdf res2 = inputOp2(p, ctx);
	return comb_diffRound(p, res1, res2, THIS_Radius);
}
