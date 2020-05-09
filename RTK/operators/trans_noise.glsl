Sdf thismap(vec3 p, Context ctx) {
	p += TDPerlinNoise(THIS_Period * p + vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz))
		* vec3(THIS_Scalex, THIS_Scaley, THIS_Scalez);
	return inputOp1(p, ctx);
}
