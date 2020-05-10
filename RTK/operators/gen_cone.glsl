Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fCone(p - THIS_Transform, THIS_Radius, THIS_Height));
}
