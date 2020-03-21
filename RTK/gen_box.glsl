Sdf thismap(vec3 p){
	p.x += @Transformx;
	p.y += @Transformy;
	p.z += @Transformz;
	Sdf res;
	res.x = fBox(p, vec3(@Scalex, @Scaley, @Scalez));
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
