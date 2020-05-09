Sdf thismap(vec3 p, Context ctx){
	Sdf res = inputOp1(p, ctx);
	res.x += sin(THIS_Period*p.x+THIS_Transformx)*sin(THIS_Period*p.y+THIS_Transformy)*sin(THIS_Period*p.z+THIS_Transformz)*THIS_Scale1;
	res.x += sin(THIS_Period*p.x*2+THIS_Transformx)*sin(THIS_Period*p.y*2+THIS_Transformy)*sin(THIS_Period*p.z*2+THIS_Transformz)*THIS_Scale2;
	res.x += sin(THIS_Period*p.x*3+THIS_Transformx)*sin(THIS_Period*p.y*3+THIS_Transformy)*sin(THIS_Period*p.z*3+THIS_Transformz)*THIS_Scale3;
	return res;
}