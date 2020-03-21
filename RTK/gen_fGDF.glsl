Sdf thismap(vec3 p){
	p.x += @Transformx;
	p.y += @Transformy;
	p.z += @Transformz;
	float d = fGDF(p, @Radius, @E, int(@Begin), int(@End));
	Sdf res;
	res.x = d;
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
