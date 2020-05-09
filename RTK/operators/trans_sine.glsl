Sdf thismap(vec3 p, Context ctx) {
	p.x += sin(p.y*THIS_Period+THIS_Transformx)*THIS_Scalex;
	p.y += sin(p.z*THIS_Period+THIS_Transformy)*THIS_Scaley;
	p.z += sin(p.x*THIS_Period+THIS_Transformx)*THIS_Scalez;
	return inputOp1(p, ctx);
}
