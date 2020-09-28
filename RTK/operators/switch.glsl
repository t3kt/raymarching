Sdf thismap(THIS_COORD_TYPE p, Context ctx) {
	#if THIS_INPUT_COUNT > 0
		int i = clamp(int(THIS_Source), 0, THIS_INPUT_COUNT - 1);
		if (i == 0) {
			return THIS_INPUT_1(p, ctx);
		}
		#if THIS_INPUT_COUNT > 1
		if (i == 1) {
			return THIS_INPUT_2(p, ctx);
		}
		#endif
		#if THIS_INPUT_COUNT > 2
		if (i == 2) {
			return THIS_INPUT_3(p, ctx);
		}
		#endif
		#if THIS_INPUT_COUNT > 3
		if (i == 3) {
			return THIS_INPUT_4(p, ctx);
		}
		#endif
	#endif
	return createSdf(0);
}