Sdf thismap(vec3 p, Context ctx){
	Sdf res = inputOp1(p, ctx);
	res.x += sin(THIS_Period*p.x+THIS_Offsetx)*sin(THIS_Period*p.y+THIS_Offsety)*sin(THIS_Period*p.z+THIS_Offsetz)*THIS_Scale1;
	res.x += sin(THIS_Period*p.x*2+THIS_Offsetx)*sin(THIS_Period*p.y*2+THIS_Offsety)*sin(THIS_Period*p.z*2+THIS_Offsetz)*THIS_Scale2;
	res.x += sin(THIS_Period*p.x*3+THIS_Offsetx)*sin(THIS_Period*p.y*3+THIS_Offsety)*sin(THIS_Period*p.z*3+THIS_Offsetz)*THIS_Scale3;
	return res;
}