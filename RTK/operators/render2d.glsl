uniform int displayGrid;
uniform vec2 enableReflectRefract = vec2(1);

out vec4 fragColor;
out vec4 depthBuffer;

Sdf map(vec2 q)
{
	Sdf res = thismap(q);
	res.x *= 0.5;
	return res;
}

void main()
{
	vec2 resolution = uTDOutputInfo.res.zw;
	vec2 fragCoord = vUV.st;//*resolution;

	Sdf res = map(fragCoord*2.0 - vec2(1));

	vec3 col = vec3(0);
	float m = res.y;
	float d = res.x;

	// ===========Additional Material is inserted here===================
	// #include <materialParagraph>
	// ==================================================================

	fragColor = TDOutputSwizzle(vec4(col, 1.0));
	depthBuffer = TDOutputSwizzle(vec4(d));
}
