Sdf thismap(vec2 p, Context ctx) {
	p -= THIS_Translate;
	pR(p, radians(THIS_Rotate));
	return createSdf(sdTrapezoid(p, THIS_Bottomwidth, THIS_Topwidth, THIS_Height));
}