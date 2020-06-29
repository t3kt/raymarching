Sdf thismap(vec3 p, Context ctx) {
	return inputOp1(((p-THIS_Pivot)* rotateMatrix(THIS_Rotate)) + THIS_Pivot, ctx);
}