Sdf thismap(vec3 p, Context ctx) {
	Sdf s = inputOp1(p, ctx);
	s.y = 1;
	return s;
}
