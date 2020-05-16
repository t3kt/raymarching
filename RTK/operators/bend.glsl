Sdf thismap(vec3 p, Context ctx) {
    float c = cos(radians(THIS_Amount)*p.PLANEPART1);
    float s = sin(radians(THIS_Amount)*p.PLANEPART1);
    vec3 q = p + THIS_Offset;
    q.PLANE *= mat2(c,-s,s,c);
	return inputOp1(q - THIS_Offset, ctx);
}
