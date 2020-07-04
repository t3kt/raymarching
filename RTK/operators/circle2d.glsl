Sdf thismap(vec2 p, Context ctx) {
	return createSdf(length(p - THIS_Translate) - THIS_Radius);
}
