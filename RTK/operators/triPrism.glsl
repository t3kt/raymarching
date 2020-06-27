Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdTriPrism((p - THIS_Translate)*TDRotateOnAxis(radians(THIS_Rotate), vec3(0, 0, 1)), vec2(THIS_Radius, THIS_Height)));
}
