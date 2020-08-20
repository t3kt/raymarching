float thismap(vec3 p, Context ctx) {
	float dataPos = p.AXIS / THIS_Period + THIS_Offset;
	int extendMode = int(THIS_Extend);
	vec4 result;
	if (extendMode == EXTEND_MENU_ZERO) {
		if (dataPos < 0 || dataPos > 1) {
			result = vec4(0);
		} else {
			result = texture(THIS_dataTex, vec2(dataPos, 0));
		}
	} else {
		if (extendMode == EXTEND_MENU_HOLD) {
			dataPos = clamp(dataPos, 0, 1);
		} else if (extendMode == EXTEND_MENU_REPEAT) {
			dataPos = fract(dataPos);
		} else if (extendMode == EXTEND_MENU_MIRROR) {
			dataPos = modZigZag(dataPos);
		}
		result = texture(THIS_dataTex, vec2(dataPos, 0));
	}
	return result.r;
}
