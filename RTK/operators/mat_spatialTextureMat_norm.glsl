Sdf thismap(vec3 p, Context ctx){
	int matID = @matID;
	Sdf res;
	res.x = inputOp1(p, ctx).x;
	res.y = matID;
	res.refract = false;
	res.reflect = false;
	
	vec3 uv = p;
	uv *= TDRotateOnAxis(radians(@Rotatex),vec3(1,0,0));
	uv *= TDRotateOnAxis(radians(@Rotatey),vec3(0,1,0));
	uv *= TDRotateOnAxis(radians(@Rotatez),vec3(0,0,1));
	uv /= vec3(@Scalex, @Scaley, @Scalez);
	uv -= vec3(@Offsetx, @Offsety, @Offsetz);
	res.norm = vec4(texture(@normalMap, uv.PLANE_PARTS).rgb, 1);
	
	return res;
}
