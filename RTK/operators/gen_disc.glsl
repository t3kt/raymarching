Sdf thismap(vec3 p, Context ctx) {
	return createSdf(fDisc(p - vec3(THIS_Translatex, THIS_Translatey, THIS_Translatez), THIS_Radius));
}
