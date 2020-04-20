Sdf thismap(vec3 p, Context ctx){
	return gen_blob(
		p,
		vec3(@Transformx, @Transformy, @Transformz)
	);
}
