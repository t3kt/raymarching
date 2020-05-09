Sdf thismap(vec3 p, Context ctx){
	return gen_mandelbulb(
		p,
		vec3(THIS_Translatex, THIS_Translatey, THIS_Translatez),
		THIS_Power,
		radians(vec2(THIS_Thetashift, THIS_Phishift)));
}
