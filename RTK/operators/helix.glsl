Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdHelix(
		(p - THIS_Translate) * TDRotateOnAxis(radians(THIS_Spin), vec3(0, 1, 0)),
		THIS_Radius, THIS_Thickness, THIS_Spread,
		THIS_Dualspread * THIS_Radius));
}
