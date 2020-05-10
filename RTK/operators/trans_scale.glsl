Sdf thismap(vec3 p, Context ctx) {
	// Not sure this is correct
	vec3 scaleVec = THIS_Scale;
	p /= scaleVec;
	Sdf res = inputOp1(p, ctx);
	res.x /= length(scaleVec);
	return res;
}
