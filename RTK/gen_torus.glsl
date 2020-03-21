Sdf thismap(vec3 p){
	p.x+=@Transformx;
	p.y+=@Transformy;
	p.z+=@Transformz;
	Sdf res;
	res.x = fTorus(p, @Rad1, @Rad2-0.1);
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
