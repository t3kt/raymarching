Sdf thismap(vec2 p, Context ctx) {
	p -= THIS_Translate;
	pR(p, radians(THIS_Rotate));
	return createSdf(sdHorseshoe(p, vec2(THIS_Angle1, THIS_Angle2), THIS_Radius, vec2(THIS_Length, THIS_Thickness)));;
}
