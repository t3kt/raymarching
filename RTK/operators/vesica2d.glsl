Sdf thismap(vec2 p, Context ctx) {
	p -= THIS_Translate;
	pR(p, radians(THIS_Rotate));
	return createSdf(sdVesica(p, THIS_Radius, THIS_Distance));
}