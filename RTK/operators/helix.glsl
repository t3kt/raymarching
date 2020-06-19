Sdf thismap(vec3 p, Context ctx) {
	p *= TDRotateOnAxis(radians(THIS_Spin), vec3(0, 1, 0));
	return createSdf(sdHelix(
		p - THIS_Translate,
		THIS_Radius, THIS_Thickness, THIS_Spread,
		THIS_Dualspread * THIS_Radius));
}
