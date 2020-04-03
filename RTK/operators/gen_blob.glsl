Sdf thismap(vec3 p){
	return gen_blob(
		p,
		vec3(@Transformx, @Transformy, @Transformz)
	);
}
