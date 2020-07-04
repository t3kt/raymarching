Sdf thismap(vec2 p, Context ctx) {
	p -= THIS_Translate;
	pR(p, radians(THIS_Rotate));
	return createSdf(sdPie(p, THIS_C, THIS_Radius));
}