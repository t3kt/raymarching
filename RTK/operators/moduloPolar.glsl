Sdf thismap(vec3 p, Context ctx) {
	vec3 offset = THIS_Offset;
	p += offset;
BODY();
	p -= offset; 
	return inputOp1(p, ctx);
}