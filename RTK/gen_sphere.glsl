Sdf thismap(vec3 p){
	float matID = 2;
	p.x += @Transformx;
	p.y += @Transformy;
	p.z += @Transformz;

	Sdf res;
	res.x = length(p)-@Radius;
	res.y = matID;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
