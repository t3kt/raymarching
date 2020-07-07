Sdf thismap(vec2 p, Context ctx) {
	return createSdf(sdRoundedX(p-THIS_Translate, THIS_Size, THIS_Roundness));
}