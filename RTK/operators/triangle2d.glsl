Sdf thismap(vec2 p, Context ctx) {
	return createSdf(sdTriangle(p - THIS_Translate, THIS_Point1, THIS_Point2, THIS_Point3));
}