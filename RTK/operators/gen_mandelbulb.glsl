Sdf thismap(vec3 p, Context ctx){
	return gen_mandelbulb(
		p,
		vec3(@Translatex, @Translatey, @Translatez),
		@Power,
		radians(vec2(@Thetashift, @Phishift)));
}
