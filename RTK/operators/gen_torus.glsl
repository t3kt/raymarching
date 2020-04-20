Sdf thismap(vec3 p, Context ctx){
	return gen_torus(
			p,
			vec3(@Transformx, @Transformy, @Transformz),
			vec2(@Rad1, @Rad2)
	);
}
