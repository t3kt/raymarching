Sdf thismap(vec3 p, Context ctx) {
	float angle = radians(THIS_Angle);
	return createSdf(sdSolidAngle(
		(p - THIS_Translate) * rotateMatrix(radians(THIS_Rotate)),
		vec2(sin(angle), cos(angle)),
		THIS_Radius));
}
