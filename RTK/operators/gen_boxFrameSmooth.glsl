Sdf thismap(vec3 p, Context ctx){
	return gen_boxFrameSmooth(
		p,
		vec3(THIS_Transformx, THIS_Transformy, THIS_Transformz),
		vec3(THIS_Scalex, THIS_Scaley, THIS_Scalez),
		THIS_Radius, THIS_Smoothing
	);
}
