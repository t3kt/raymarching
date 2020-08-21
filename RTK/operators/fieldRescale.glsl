THIS_RETURN_TYPE thismap(THIS_COORD_TYPE p, Context ctx) {
	THIS_RETURN_TYPE val = inputOp1(p, ctx);
	#ifdef THIS_RETURN_TYPE_Sdf
	val.x = mapRange(val.x, THIS_Fromlow1, THIS_Fromhigh1, THIS_Tolow1, THIS_Tohigh1);
	#endif
	#ifdef THIS_RETURN_TYPE_float
	val = mapRange(val, THIS_Fromlow1, THIS_Fromhigh1, THIS_Tolow1, THIS_Tohigh1);
	#endif
	#ifdef THIS_RETURN_TYPE_vec4
	val = mapRange(val, THIS_Fromlow, THIS_Fromhigh, THIS_Tolow, THIS_Tohigh);
	#endif
	if (THIS_Clamp > 0) {
		#ifdef THIS_RETURN_TYPE_Sdf
		val.x = clamp(val.x, THIS_Tolow1, THIS_Tohigh1);
		#endif
		#ifdef THIS_RETURN_TYPE_float
		val = clamp(val, THIS_Tolow1, THIS_Tohigh1);
		#endif
		#ifdef THIS_RETURN_TYPE_vec4
		val = clamp(val, THIS_Tolow, THIS_Tohigh);
		#endif
	}
	return val;
}
