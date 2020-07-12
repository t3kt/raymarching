Sdf thismap(vec3 p, Context ctx) {
	return gen_mandelbulb(p, THIS_Translate, THIS_Power, radians(vec2(THIS_Thetashift, THIS_Phishift)));
}
