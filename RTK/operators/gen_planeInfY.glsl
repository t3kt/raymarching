Sdf thismap(vec3 p){
	return gen_planeInfY(
		p,
		vec3(@Transformx, @Transformy, @Transformz)
	);
}
