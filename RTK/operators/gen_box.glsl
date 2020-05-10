Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fBox(p - THIS_Transform, THIS_Scale));
}
