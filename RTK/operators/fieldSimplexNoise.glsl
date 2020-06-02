vec4 thismap(vec3 p, Context ctx) {
	return vec4(THIS_Offset + THIS_Amp * TDSimplexNoise((p / THIS_Uniformscale / THIS_Scale)  + THIS_Translate), 0, 0, 0);
}
