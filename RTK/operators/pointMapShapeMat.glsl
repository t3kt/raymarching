Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	res.y = THIS_matID;
	return res;
}

vec3 THIS_getColor(Sdf res, vec3 p) {
	vec3 col = THIS_Fillcolor;


	return col;
}
