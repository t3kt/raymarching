Sdf thismap(vec2 p, Context ctx) {
	p -= THIS_Translate;
	pR(p, radians(THIS_Rotate));
	return createSdf(sdOctagon(p, THIS_Radius));
}