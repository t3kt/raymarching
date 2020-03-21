#include "hg_sdf"

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

void pModMirrorXY(inout vec3 p, vec2 size) {
	vec2 temp = p.xy;
	pModMirror2(temp, size);
	p.xy = temp;
}

void pModMirrorYZ(inout vec3 p, vec2 size) {
	vec2 temp = p.yz;
	pModMirror2(temp, size);
	p.yz = temp;
}

void pModMirrorXZ(inout vec3 p, vec2 size) {
	vec2 temp = p.xz;
	pModMirror2(temp, size);
	p.xz = temp;
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
