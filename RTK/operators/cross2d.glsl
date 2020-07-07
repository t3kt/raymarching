Sdf thismap(vec2 p, Context ctx) {
	return createSdf(sdCross(p-THIS_Translate, vec2(THIS_Outersize, THIS_Innersize), THIS_Roundness));
}