Sdf thismap(vec3 p, Context ctx) {
	return createSdf(length(p - THIS_Transform)-THIS_Radius);
}
