Sdf thismap(vec3 p, Context ctx){
	return gen_boxFrameSmooth(p, THIS_Transform, THIS_Scale, THIS_Radius, THIS_Smoothing);
}
