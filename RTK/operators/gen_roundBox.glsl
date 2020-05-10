Sdf thismap(vec3 p, Context ctx) {
	vec3 d = abs(p - THIS_Transform)-THIS_Scale;
	return createSdf(length(max(d,0.))-THIS_Radius);
}
