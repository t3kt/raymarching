THIS_RETURN_TYPE thismap(vec3 p, Context ctx) {
	float dataPos = p.AXIS / THIS_Period + THIS_Offset;
	int extendMode = int(THIS_Extend);
	vec4 result = textureLookup(THIS_dataTex, vec2(dataPos, 0), int(THIS_Extend));
#ifdef THIS_RETURN_TYPE_vec4
	return result;
#else
	return result.r;
#endif
}
