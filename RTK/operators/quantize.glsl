Sdf thismap(vec3 p, Context ctx) {
	return inputOp1(trans_quantizeXYZ(p, THIS_Size, THIS_Offset, THIS_Smooth), ctx);
}
