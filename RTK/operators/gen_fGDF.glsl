Sdf thismap(vec3 p, Context ctx) {
	vec3 t = vec3(THIS_Translatex, THIS_Translatey, THIS_Translatez);
	if (THIS_Useexponent > 0.5) {
		return createSdf(fGDF(p - t, THIS_Radius, THIS_E, int(THIS_Begin), int(THIS_End)));
	} else {
		return createSdf(fGDF(p - t, THIS_Radius, int(THIS_Begin), int(THIS_End)));
	}
}
