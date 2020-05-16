Sdf thismap(vec3 p, Context ctx) {
	return createSdf(sdLink(p - THIS_Translate, THIS_Length, THIS_Radius, THIS_Thickness));
}
