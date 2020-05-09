Sdf thismap(vec3 p, Context ctx) {
	// Not sure this is correct
	vec3 scaleVec = vec3(THIS_Scalex, THIS_Scaley, THIS_Scalez);
	p /= scaleVec;
	Sdf res = inputOp1(p, ctx);
	res.x /= length(scaleVec);
	return res;
}
