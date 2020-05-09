Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fBlob(p - vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz)));
}
