Sdf thismap(vec3 p, Context ctx) {
	return createSdf(
		sdMengerSponge(p - THIS_Translate, int(THIS_Steps), THIS_Scale, THIS_Crossscale, THIS_Boxscale));
}