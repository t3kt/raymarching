Sdf thismap(vec3 p, Context ctx) {
	vec3 d = abs(p - vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz))-vec3(THIS_Scalex, THIS_Scaley, THIS_Scalez);
	return createSdf(length(max(d,0.))-THIS_Radius);
}
