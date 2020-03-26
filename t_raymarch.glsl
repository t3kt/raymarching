#include "hg_sdf"
#include "rtk_common"

float map(float value, float inMin, float inMax, float outMin, float outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec2 map(vec2 value, vec2 inMin, vec2 inMax, vec2 outMin, vec2 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec3 map(vec3 value, vec3 inMin, vec3 inMax, vec3 outMin, vec3 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec4 map(vec4 value, vec4 inMin, vec4 inMax, vec4 outMin, vec4 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

float pModPolarXY(inout vec3 p, float repetitions) {
	vec2 temp = p.xy;
	float result = pModPolar(temp, repetitions);
	p.xy = temp;
	return result;
}

float pModPolarXZ(inout vec3 p, float repetitions) {
	vec2 temp = p.xz;
	float result = pModPolar(temp, repetitions);
	p.xz = temp;
	return result;
}

float pModPolarYZ(inout vec3 p, float repetitions) {
	vec2 temp = p.yz;
	float result = pModPolar(temp, repetitions);
	p.yz = temp;
	return result;
}

void pMirrorOctantXY(inout vec3 p, vec2 dist) {
	vec2 temp = p.xy;
	pMirrorOctant(temp, dist);
	p.xy = temp;
}

void pMirrorOctantXZ(inout vec3 p, vec2 dist) {
	vec2 temp = p.xz;
	pMirrorOctant(temp, dist);
	p.xz = temp;
}
void pMirrorOctantYZ(inout vec3 p, vec2 dist) {
	vec2 temp = p.yz;
	pMirrorOctant(temp, dist);
	p.yz = temp;
}

vec2 pModMirrorXY(inout vec3 p, vec2 size) {
	vec2 temp = p.xy;
	vec2 result = pModMirror2(temp, size);
	p.xy = temp;
	return result;
}

vec2 pModMirrorYZ(inout vec3 p, vec2 size) {
	vec2 temp = p.yz;
	vec2 result = pModMirror2(temp, size);
	p.yz = temp;
	return result;
}

vec2 pModMirrorXZ(inout vec3 p, vec2 size) {
	vec2 temp = p.xz;
	vec2 result = pModMirror2(temp, size);
	p.xz = temp;
	return result;
}

vec2 pModGridXY(inout vec3 p, vec2 size) {
	vec2 temp = p.xy;
	vec2 result = pModGrid2(temp, size);
	p.xy = temp;
	return result;
}

vec2 pModGridXZ(inout vec3 p, vec2 size) {
	vec2 temp = p.xz;
	vec2 result = pModGrid2(temp, size);
	p.xz = temp;
	return result;
}

vec2 pModGridYZ(inout vec3 p, vec2 size) {
	vec2 temp = p.yz;
	vec2 result = pModGrid2(temp, size);
	p.yz = temp;
	return result;
}

void pRotateOnXYZ(inout vec3 p, vec3 rotation) {
    vec2 temp;
    temp = p.xy;
    pR(temp, rotation.z);
    p.xy = temp;
    temp = p.xz;
    pR(temp, rotation.y);
    p.xz = temp;
    temp = p.yz;
    pR(temp, rotation.x);
    p.yz = temp;
}

void pModPolarZigZag(inout vec2 p, float repetitions) {
	float angle = 2*PI/repetitions;
	float a = atan(p.y, p.x);
	a += angle / 2.;
	float r = length(p);
	float moddedA = mod(a, angle*2.);
	if (moddedA > angle) {
//		moddedA = angle - moddedA;
	}
	p = vec2(cos(moddedA), sin(moddedA)) * r;
}

void pModPolarZigZagXY(inout vec3 p, float repetitions) {
	vec2 temp = p.xy;
	pModPolarZigZag(temp, repetitions);
	p.xy = temp;
}

void pModPolarZigZagXZ(inout vec3 p, float repetitions) {
	vec2 temp = p.xz;
	pModPolarZigZag(temp, repetitions);
	p.xz = temp;
}

void pModPolarZigZagYZ(inout vec3 p, float repetitions) {
	vec2 temp = p.yz;
	pModPolarZigZag(temp, repetitions);
	p.yz = temp;
}


