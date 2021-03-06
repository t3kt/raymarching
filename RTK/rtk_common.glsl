// =======================================================================
// =======================================================================
// =====================----MY ADDITIONS
//============(of course thanks to IQ and everyone else.)
// =======================================================================
// =======================================================================

struct Sdf
{
	float x; // distance
	float y; // material ID
	bool reflect; // do reflection for this?
	bool refract; // do refraction for this?
	float material2; // in case of interpolating, the second material
	float interpolant; // in case of interpolating, the interpolation value
	float ior; // index of refraction in case of refraction
};

Sdf createSdf(float dist) {
	float matID = 2;
	Sdf res;
	res.x = dist;
	res.y = matID;
	res.reflect = false;
	res.refract = false;
	res.material2 = 0.;
	res.interpolant = 0.;
	return res;
}

struct Context {
	int iteration;
	int total;
};

Context defaultContext() {
	Context ctx;
	ctx.iteration = 0;
	ctx.total = 1;
	return ctx;
}

struct MatInputs {
	Sdf res;
	vec3 pos;
	vec3 n;
	vec3 ref;
	vec3 refraction;
	vec3 eye;
	float occ;
	float occ2;
	float t;
	vec3 rd;
};

vec3 opTwist(vec3 p, float k){
	// const float k = 10.0;
	float c = cos(k*p.y);
	float s = sin(k*p.y);
	mat2 m = mat2(c,-s,s,c);
	vec3 q = vec3(m*p.xy, p.y);
	return q;

}


float opOnion(float d, float thickness){
	return abs(d)-thickness;

}


float fGyroid(vec3 p, float scale, float bias, float thickness) {
    p *= scale;
    float d = abs(dot(sin(p), cos(p.yzx))+bias)-thickness;
    return d/scale;
}


void pModTorus_maybeXZ(inout vec3 p, float repetitions) {
	p = vec3(length(p.xz)-repetitions, p.y, atan(p.x, p.z));
}

void pModTorus_maybeXY(inout vec3 p, float repetitions) {
	float angle = 2*PI/repetitions;
	p = vec3(length(p.xy)-angle, atan(p.x, p.y), p.z);
}


float hash1( float n )
{
    return fract(sin(n)*43758.5453123);
}

float hash1( in vec2 f )
{
    return fract(sin(f.x+131.1*f.y)*43758.5453123);
}

float sampledRandom(in vec2 p) {
	return texture(sTDNoiseMap, mod(p + vec2(17, 89), vec2(256))).r;
}

vec2 proceduralWhiteNoise(in vec2 p) {
	return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

Sdf distGrid(in vec3 p, float elev){
	Sdf res;
	res.x = p.y-elev;
	res.y = 10;
	res.refract = false;
	res.reflect = false;
	res.material2 = 10.;
	res.interpolant = 0.;
	return res;
}

vec2 cartopol( vec2 p){
    float ang = atan(p.x,p.y);
    float rad = sqrt(p.x*p.x + p.y*p.y);
    return vec2(rad, ang);
}


vec2 poltocar(vec2 ra){
    float px = sin(ra.y)*ra.x;
    float py = cos(ra.y)*ra.x;

    return vec2(px,py);
}

float opSubtraction( float d1, float d2 ) { return max(-d1,d2); }

float opSmoothUnion( float d1, float d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h); }


Sdf opSmoothUnionM( Sdf d1, Sdf d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2.x-d1.x)/k, 0.0, 1.0 );
    float resx = mix( d2.x, d1.x, h ) - k*h*(1.0-h);
    // float resy = mix( d2.y, d1.y, h ) - k*h*(1.0-h);
    Sdf res;
    res.x = resx;
    res.y = d2.y;
    res.material2 = d1.y;
    res.interpolant = h;
    res.refract = d1.refract || d2.refract;
    res.reflect = d1.reflect || d2.reflect;
    // res.refract = false;
    // res.reflect = false;
    return res;//vec2(resx, resy); }
}

Sdf opUnionSoft(Sdf d1, Sdf d2, float k) {
	// this line is just copied over from opSmoothUnionM... not sure if it's correct
    float h = clamp( 0.5 + 0.5*(d2.x-d1.x)/k, 0.0, 1.0 );
	Sdf res;
	res.x = fOpUnionSoft(d1.x, d2.x, k);
	res.y = d2.y;
  res.material2 = d1.y;
  res.interpolant = h;
  res.refract = d1.refract || d2.refract;
  res.reflect = d1.reflect || d2.reflect;
  // res.refract = false;
  // res.reflect = false;
  return res;//vec2(resx, resy); }
}

#ifdef RTK_USE_QUAD_FRAME_SMOOTH

float fQuadFrameSmooth(vec3 p, vec2 size, float radius, float smoothing) {
	// top left-right
	float dist = fCapsule(p,
		vec3(size * vec2(-0.5, 0.5), 0),
		vec3(size * vec2(0.5, 0.5), 0),
		radius);
	// bottom left-right
	dist = fOpUnionSoft(dist, fCapsule(p,
		vec3(size * vec2(-0.5, -0.5), 0),
		vec3(size * vec2(0.5, -0.5), 0),
		radius), smoothing);
	// top-bottom left
	dist = fOpUnionSoft(dist, fCapsule(p,
		vec3(size * vec2(-0.5, 0.5), 0),
		vec3(size * vec2(-0.5, -0.5), 0),
		radius), smoothing);
	// top-bottom right
	dist = fOpUnionSoft(dist, fCapsule(p,
		vec3(size * vec2(0.5, 0.5), 0),
		vec3(size * vec2(0.5, -0.5), 0),
		radius), smoothing);
	return dist;
}

#endif // RTK_USE_QUAD_FRAME_SMOOTH

#ifdef RTK_USE_BOX_FRAME_SMOOTH

float fBoxFrameSmooth(vec3 p, vec3 size, float radius, float smoothing) {
	// front top left-right
	float dist = fCapsule(
		p,
		vec3(-0.5, 0.5, -0.5) * size,
		vec3(0.5, 0.5, -0.5) * size,
		radius);
	// front bottom left-right
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(-0.5, -0.5, -0.5) * size,
		vec3(0.5, -0.5, -0.5) * size,
		radius
	), smoothing);
	// front top-bottom left
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(-0.5, 0.5, -0.5) * size,
		vec3(-0.5, -0.5, -0.5) * size,
		radius
	), smoothing);
	// front top-bottom right
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(0.5, 0.5, -0.5) * size,
		vec3(0.5, -0.5, -0.5) * size,
		radius
	), smoothing);

	// back top left-right
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(-0.5, 0.5, 0.5) * size,
		vec3(0.5, 0.5, 0.5) * size,
		radius), smoothing);
	// back bottom left-right
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(-0.5, -0.5, 0.5) * size,
		vec3(0.5, -0.5, 0.5) * size,
		radius
	), smoothing);
	// back top-bottom left
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(-0.5, 0.5, 0.5) * size,
		vec3(-0.5, -0.5, 0.5) * size,
		radius
	), smoothing);
	// back top-bottom right
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(0.5, 0.5, 0.5) * size,
		vec3(0.5, -0.5, 0.5) * size,
		radius
	), smoothing);

	// front-back top left
	dist = fOpUnionSoft(dist, fCapsule(
		p,
		vec3(-0.5, 0.5, 0.5) * size,
		vec3(-0.5, 0.5, -0.5) * size,
		radius
	), smoothing);

//	float d1 = fQuadFrameSmooth(
//		p - vec3(0, 0, 0.5) * size,
//		size.xy,
//		radius, smoothing);
//	float d2 = fQuadFrameSmooth(
//		p + vec3(0, 0, 0.5) * size,
//		size.xy,
//		radius, smoothing);
//	float dist = fOpUnionSoft(d1, d2, smoothing);

//	float d2 = fCapsule(
//		p + vec3(0.5, 0.5, 0)*size,
//		vec3(0, 0, 0.5) * size,
//		vec3(0, 0, -0.5) * size,
//		radius
//	);

	return dist;
}

#endif // RTK_USE_BOX_FRAME_SMOOTH

mat3 rotateMatrix(vec3 r) {
	return TDRotateOnAxis(r.x, vec3(1, 0, 0)) *
		TDRotateOnAxis(r.y, vec3(0, 1, 0)) *
		TDRotateOnAxis(r.z, vec3(0, 0, 1));
}

vec3 scaleRotateTranslate(vec3 pos, vec3 translate, vec3 rotate, vec3 scale, vec3 pivot) {
	pos -= pivot;
//	pos *= rotateMatrix(rotate);
	pos *= TDRotateOnAxis(rotate.x, vec3(1, 0, 0));
	pos *= TDRotateOnAxis(rotate.y, vec3(0, 1, 0));
	pos *= TDRotateOnAxis(rotate.z, vec3(0, 0, 1));
	pos /= scale;
	pos -= translate;
	pos += pivot;
	return pos;
}

float sdCross(vec3 p, vec3 size )
{
  float da = fBox2(p.xy,size.xy);
  float db = fBox2(p.yz,size.yz);
  float dc = fBox2(p.zx,size.zx);
  return min(da,min(db,dc));
}

int quadrantIndex(ivec2 cell) {
		/*
		[0] -1, 1    [1] 1, 1
		[2] -1, -1   [3] 1, -1
		*/
		return (((cell.y + 1) / 2) * 2) + ((cell.x + 1) / 2);
}

float ndot( in vec2 a, in vec2 b ) { return a.x*b.x - a.y*b.y; }
float dot2( in vec2 v ) { return dot(v,v); }
float dot2( in vec3 v ) { return dot(v,v); }

// https://github.com/msfeldstein/glsl-map/blob/master/index.glsl

float mapRange(float value, float inMin, float inMax, float outMin, float outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec2 mapRange(vec2 value, vec2 inMin, vec2 inMax, vec2 outMin, vec2 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec3 mapRange(vec3 value, vec3 inMin, vec3 inMax, vec3 outMin, vec3 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec4 mapRange(vec4 value, vec4 inMin, vec4 inMax, vec4 outMin, vec4 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

float map01(float value, float inMin, float inMax) {
  return (value - inMin) / (inMax - inMin);
}

vec2 map01(vec2 value, vec2 inMin, vec2 inMax) {
  return (value - inMin) / (inMax - inMin);
}

vec3 map01(vec3 value, vec3 inMin, vec3 inMax) {
  return (value - inMin) / (inMax - inMin);
}

vec4 map01(vec4 value, vec4 inMin, vec4 inMax) {
  return (value - inMin) / (inMax - inMin);
}

// https://github.com/glslify/glsl-easings
float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

#define linear(t) (t)

// numeric values of "Extend" par menu items
#define EXTEND_MENU_HOLD 0
#define EXTEND_MENU_ZERO 1
#define EXTEND_MENU_REPEAT 2
#define EXTEND_MENU_MIRROR 3


float modZigZag(float p) {
	float modded = mod(p, 2.);
	if (modded > 1) {
		return 2 - modded;
	}
	return modded;
}
vec2 modZigZag(vec2 p) {
	vec2 modded = mod(p, 2.);
	return vec2(
		modded.x > 1 ? (2 - modded.x) : modded.x,
		modded.y > 1 ? (2 - modded.y) : modded.y);
}

vec4 textureLookup(sampler2D sampler, vec2 coord, int extendMode) {
	switch(extendMode) {
		case EXTEND_MENU_HOLD:
			return texture(sampler, clamp(coord, 0, 1));
		case EXTEND_MENU_ZERO:
			if (coord.x >= 0 && coord.x <= 1 && coord.y >= 0 && coord.y <= 1) {
				return texture(sampler, coord);
			} else {
				return vec4(0);
			}
		case EXTEND_MENU_MIRROR:
			return texture(sampler, modZigZag(coord));
		default:
			return texture(sampler, fract(coord));
	}
}
