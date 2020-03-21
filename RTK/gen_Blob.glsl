Sdf thismap(vec3 p){
	p.x += @Transformx;
	p.y += @Transformy;
	p.z += @Transformz;
	Sdf res;
	res.x = fBlob(p);
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
