Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fBlob(p - THIS_Transform));
}
