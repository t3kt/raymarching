#ifndef RTK_TRANFORMS
#define RTK_TRANFORMS

#ifdef RTK_USE_MODULO

vec3 trans_moduloX(vec3 p, float size, float shiftX, float mirror) {
	float temp = p.x + shiftX;
	if (mirror > 0.5) { pModMirror1(temp, size); }
	else { pMod1(temp, size); }
	p.x = temp;
	return p;
}

vec3 trans_moduloY(vec3 p, float size, float shift, float mirror) {
	float temp = p.y + shift;
	if (mirror > 0.5) { pModMirror1(temp, size); }
	else { pMod1(temp, size); }
	p.y = temp;
	return p;
}

vec3 trans_moduloZ(vec3 p, float size, float shift, float mirror) {
	float temp = p.z + shift;
	if (mirror > 0.5) { pModMirror1(temp, size); }
	else { pMod1(temp, size); }
	p.z = temp;
	return p;
}

vec3 trans_moduloXY(vec3 p, float sizeX, float sizeY, float shiftX, float shiftY, float mirror) {
	vec2 temp = p.xy + vec2(shiftX, shiftY);
	if (mirror > 0.5) { pModMirror2(temp, vec2(sizeX, sizeY)); }
	else { pMod2(temp, vec2(sizeX, sizeY)); }
	p.xy = temp;
	return p;
}

vec3 trans_moduloXZ(vec3 p, float sizeX, float sizeZ, float shiftX, float shiftZ, float mirror) {
	vec2 temp = p.xz + vec2(shiftX, shiftZ);
	if (mirror > 0.5) { pModMirror2(temp, vec2(sizeX, sizeZ)); }
	else { pMod2(temp, vec2(sizeX, sizeZ)); }
	p.xz = temp;
	return p;
}

vec3 trans_moduloYZ(vec3 p, float sizeY, float sizeZ, float shiftY, float shiftZ, float mirror) {
	vec2 temp = p.yz + vec2(shiftY, shiftZ);
	if (mirror > 0.5) { pModMirror2(temp, vec2(sizeY, sizeZ)); }
	else { pMod2(temp, vec2(sizeY, sizeZ)); }
	p.yz = temp;
	return p;
}

vec3 trans_moduloXYZ(vec3 p, float sizeX, float sizeY, float sizeZ, float shiftX, float shiftY, float shiftZ) {
	// TODO: MIRROR SUPPORT
	p += vec3(shiftX, shiftY, shiftZ);
	pMod3(p, vec3(sizeX, sizeY, sizeZ));
	return p;
}

#endif // RTK_USE_MODULO

#ifdef RTK_USE_MIRROR_OCTANT

vec3 trans_mirrorOctantXY(vec3 p, float sizeX, float sizeY, float offsetX, float offsetY, float rotateAxis) {
	mat3 r = TDRotateOnAxis(radians(rotateAxis), vec3(0, 0, 1));
	p *= r;
	vec2 offset = vec2(offsetX, offsetY);
	vec2 temp = p.xy + offset;
	pMirrorOctant(temp, vec2(sizeX, sizeY));
	p.xy = temp - offset;
	p *= -r;
	return p;
}

vec3 trans_mirrorOctantXZ(vec3 p, float sizeX, float sizeZ, float offsetX, float offsetZ, float rotateAxis) {
	mat3 r = TDRotateOnAxis(radians(rotateAxis), vec3(0, 1, 0));
	p *= r;
	vec2 offset = vec2(offsetX, offsetZ);
	vec2 temp = p.xz + offset;
	pMirrorOctant(temp, vec2(sizeX, sizeZ));
	p.xz = temp - offset;
	p *= -r;
	return p;
}

vec3 trans_mirrorOctantYZ(vec3 p, float sizeY, float sizeZ, float offsetY, float offsetZ, float rotateAxis) {
	mat3 r = TDRotateOnAxis(radians(rotateAxis), vec3(1, 0, 0));
	p *= r;
	vec2 offset = vec2(offsetY, offsetZ);
	vec2 temp = p.yz + offset;
	pMirrorOctant(temp, vec2(sizeY, sizeZ));
	p.yz = temp - offset;
	p *= -r;
	return p;
}

#endif // RTK_USE_MIRROR_OCTANT

#ifdef RTK_USE_QUANTIZE

float gain(float x, float k)
{
    float a = 0.5*pow(2.0*((x<0.5)?x:1.0-x), k);
    return (x<0.5)?a:1.0-a;
}
vec3 gain(vec3 x, vec3 k)
{
	return vec3(gain(x.x, k.x), gain(x.y, k.y), gain(x.z, k.z));
}

vec3 trans_quantizeXYZ(vec3 p, vec3 size, vec3 offset, vec3 smoothing) {
	p = (p + offset) / size;
	return ((floor(p) + gain(fract(p), smoothing)) * size) - offset;
}

#endif

#ifdef RTK_USE_WAVE

#define wave_sin(x)  sin(x * TAU)
#define wave_cos(x)  cos(x * TAU)
#define wave_tri(x)  (abs(4.*fract(x)-2.)-1.)
#define wave_square(x) (2.*step(fract(x), 0.5)-1.)
#define wave_ramp(x)  fract(x)

#endif // RTK_USE_WAVE

#endif // RTK_TRANFORMS
