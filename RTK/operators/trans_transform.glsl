Sdf thismap(vec3 p, Context ctx) {
	p = scaleRotateTranslate(p, THIS_Translate, radians(THIS_Rotate), THIS_Scale, THIS_Pivot);
	return inputOp1(p, ctx);
}
