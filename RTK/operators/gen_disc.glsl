Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fDisc(p - THIS_Translate, THIS_Radius));
}
