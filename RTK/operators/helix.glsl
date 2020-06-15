Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdHelix(
		p - THIS_Translate,
		THIS_Radius, THIS_Thickness, THIS_Spread,
		THIS_Dualspread * THIS_Radius));
}
