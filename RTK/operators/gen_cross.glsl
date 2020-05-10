Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdCross(p - THIS_Translate, THIS_Size));
}
