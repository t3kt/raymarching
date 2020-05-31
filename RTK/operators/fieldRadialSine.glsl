vec4 thismap(vec3 p, Context ctx) {
	return vec4(THIS_Offset + sin(
			(atan(p.PLANEPART2 - THIS_Translate.PLANEPART2, p.PLANEPART1 - THIS_Translate.PLANEPART1) / THIS_Reps)
			+ (THIS_Phase * 2.0 * PI))
		* THIS_Amp, 0, 0, 0);
}
