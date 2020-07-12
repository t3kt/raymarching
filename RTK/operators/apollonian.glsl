Sdf thismap(vec3 p, Context ctx) {
	vec4 orb;
	float d = sdApollonian(p - THIS_Translate, THIS_S, THIS_Scale, orb);
	return createSdf(d);
}
