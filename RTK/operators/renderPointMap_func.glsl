Sdf thismap(vec3 p){
	Sdf res = inputOp1(p, defaultContext());
	res.y = THIS_matID;
	return res;
}
Sdf thismap(vec3 p, Context ctx){
	Sdf res = inputOp1(p, ctx);
	res.y = THIS_matID;
	return res;
}
vec4 getBackgroundColor(Sdf res) {
	return THIS_Backgroundcolor;
}
vec4 getDefaultColor(Sdf res) {
	return THIS_Defaultcolor;
}
vec4 THIS_getColor(Sdf res) {
	return getDefaultColor(res);
}
