vec4 thismap(vec3 p, Context ctx) {
	return vec4(THIS_Offset + THIS_Amp * TDPerlinNoise(THIS_Uniformscale * THIS_Scale * p + THIS_Translate), 0, 0, 0);
}
