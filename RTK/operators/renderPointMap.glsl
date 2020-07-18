uniform int displayGrid;
uniform vec2 enableReflectRefract = vec2(1);

out vec4 fragColor;

Sdf map(vec3 q)
{
	Sdf res = thismap(q);
	res.x *= 0.5;
	return res;
}

vec4 getPointColor(Sdf res, vec3 p) {
	bool matchedMat = false;
	vec4 col = vec4(0);
	float m = res.y;
	float d = res.x;

	// ===========Additional Material is inserted here===================
	// #include <materialParagraph>
	// ==================================================================


	if (d > 0) {
		col = getBackgroundColor(res);
	} else if (!matchedMat) {
		col = getDefaultColor(res);
	}
	return col;
}

void main()
{
	vec2 resolution = uTDOutputInfo.res.zw;
	vec2 fragCoord = vUV.st;//*resolution;
	vec3 p = texture(sTD2DInputs[0], fragCoord).xyz;

	Sdf res = map(p*2.0 - vec3(1));

	vec4 col = getPointColor(res, p);

	fragColor = TDOutputSwizzle(col);
}
