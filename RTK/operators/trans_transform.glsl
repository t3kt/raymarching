Sdf thismap(vec3 p, Context ctx) {
	return inputOp1(scaleRotateTranslate(p, THIS_Translate, radians(THIS_Rotate), THIS_Scale, THIS_Pivot), ctx);
}
