Sdf thismap(vec3 p, Context ctx) {
	return createSdf(length(p - vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz))-THIS_Radius);
}
