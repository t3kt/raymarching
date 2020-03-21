Sdf thismap(vec3 p){
	p.x += @Transformx;
	p.y += @Transformy;
	p.z += @Transformz;
	vec3 b = vec3(@Scalex, @Scaley, @Scalez);
	vec3 d = abs(p)-b;
	Sdf res;
	res.x = length(max(d,0.))-@Radius;
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
