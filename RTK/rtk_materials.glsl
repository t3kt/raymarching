#ifndef RTK_TRANFORMS
#define RTK_TRANFORMS

Sdf mat_checker(vec3 p, Sdf input1){
	input1.y = 1;
	return input1;
}

Sdf mat_reflect(vec3 p, Sdf input1, int matID, float refractionIndex){
	Sdf res;
	res.x = input1.x;
	res.y = matID;
	res.refract = true;
	res.reflect = true;
	res.ior = refractionIndex;
	return res;
}

Sdf mat_simple(vec3 p, Sdf input1, int matID){
	Sdf res;
	res.x = input1.x;
	res.y = matID;
	res.refract = false;
	res.reflect = false;
	return res;
}

Sdf mat_texture(vec3 p, Sdf input1, int matID){
	Sdf res;
	res.x = input1.x;
	res.y = matID;
	res.refract = false;
	res.reflect = false;
	return res;
}

#endif // RTK_TRANFORMS
