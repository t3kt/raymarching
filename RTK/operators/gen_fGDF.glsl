Sdf thismap(vec3 p, Context ctx) {
	if (THIS_Useexponent > 0.5) {
		return createSdf(fGDF(p - THIS_Translate, THIS_Radius, THIS_E, int(THIS_Begin), int(THIS_End)));
	} else {
		return createSdf(fGDF(p - THIS_Translate, THIS_Radius, int(THIS_Begin), int(THIS_End)));
	}
}
