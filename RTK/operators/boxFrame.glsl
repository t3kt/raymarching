Sdf thismap(vec3 p, Context ctx){
	return createSdf(sdBoundingBox(p - THIS_Translate, THIS_Scale, THIS_Thickness));
}
