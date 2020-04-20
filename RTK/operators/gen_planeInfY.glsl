Sdf thismap(vec3 p, Context ctx){
	return gen_planeInfY(
		p,
		vec3(@Transformx, @Transformy, @Transformz)
	);
}
