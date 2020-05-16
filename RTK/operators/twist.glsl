Sdf thismap(vec3 p, Context ctx) {
	vec3 offset = AXISVEC * THIS_Offset;
    float c = cos(THIS_Amount*p.AXIS);
    float s = sin(THIS_Amount*p.AXIS);
    vec3 q = p + offset;
    q.PLANE *= mat2(c,-s,s,c);
	return inputOp1(q - offset, ctx);
}
