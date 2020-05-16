Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdHexPrism((p*TDRotateOnAxis(radians(THIS_Rotate), vec3(0, 0, 1))) - THIS_Translate, vec2(THIS_Radius, THIS_Height)));
}
