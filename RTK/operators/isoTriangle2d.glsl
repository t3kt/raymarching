Sdf thismap(vec2 p, Context ctx) {
	p -= THIS_Translate;
	pR(p, radians(THIS_Rotate));
	return createSdf(sdTriangleIsosceles(p, vec2(THIS_Height, THIS_Width)));
}