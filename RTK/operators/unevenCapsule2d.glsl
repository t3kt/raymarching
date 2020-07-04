Sdf thismap(vec2 p, Context ctx) {
	p -= THIS_Translate;
	pR(p, radians(THIS_Rotate));
	return createSdf(sdUnevenCapsule(p, THIS_Radius1, THIS_Radius2, THIS_Height));
}