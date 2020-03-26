Sdf thismap(vec3 p){
//	p.x += @Transformx;
//	p.y += @Transformy;
//	p.z += @Transformz;
//	vec3 size = vec3(@Scalex, @Scaley, @Scalez);
//	vec3 d = abs(p)-b;
//	float frameSmooth = @Framesmooth;
//	float thickness = @Thickness;

	float frame;

	vec3 framePos = p - vec3(0, 0, 0.5 * size.z);

	// front top left-right
	frame = fCapsule(framePos,
		size * vec3(-0.5, 0.5, 0),
		size * vec3(0.5, 0.5, 0),
		thickness);
	// front bottom left-right
	frame = fOpUnionRound(frame, fCapsule(), frameSmooth);


	Sdf res;
	res.x = frame;
	res.y = 2;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}
