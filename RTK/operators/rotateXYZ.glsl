Sdf thismap(vec3 p, Context ctx) {
	return inputOp1(p * rotateMatrix(THIS_Rotate), ctx);
}
