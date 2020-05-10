Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fTorus(p - THIS_Transform, THIS_Rad1, THIS_Rad2-0.1));
}
