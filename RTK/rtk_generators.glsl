#ifndef RTK_GENERATORS
#define RTK_GENERATORS

#ifdef RTK_USE_MANDELBULB

Sdf gen_mandelbulb(vec3 p, vec3 translate, float power, vec2 shiftThetaPhi)
{
	p -= translate;


    if(length(p) > 1.5) return createSdf(length(p) - 1.2);
    vec3 z = p;
    float dr = 1.0, r = 0.0, theta, phi;
    for (int i = 0; i < 15; i++) {
        r = length(z);
        if (r>1.5) break;
        dr =  pow( r, power-1.0)*power*dr + 1.0;
        theta = acos(z.z/r) * power + shiftThetaPhi.x;
        phi = atan(z.y,z.x) * power;// + shiftThetaPhi.y;
	    if (i > 0) {
		    phi += shiftThetaPhi.y;
	    }
        float sinTheta = sin(theta);
        z = pow(r,power) * vec3(sinTheta*cos(phi), sinTheta*sin(phi), cos(theta)) + p;
    }
    return  createSdf(0.5*log(r)*r/dr);
//	vec3 w = p;
//	float m = dot(w, w);
//
//	vec4 trap = vec4(abs(w), m);
//	float dz = 1.0;
//	for (int i=0; i<4; i++)
//	{
//		#if 0
//		float m2 = m*m;
//		float m4 = m2*m2;
//		dz = 8.0*sqrt(m4*m2*m)*dz + 1.0;
//
//		float x = w.x; float x2 = x*x; float x4 = x2*x2;
//		float y = w.y; float y2 = y*y; float y4 = y2*y2;
//		float z = w.z; float z2 = z*z; float z4 = z2*z2;
//
//		float k3 = x2 + z2;
//		float k2 = inversesqrt(k3*k3*k3*k3*k3*k3*k3);
//		float k1 = x4 + y4 + z4 - 6.0*y2*z2 - 6.0*x2*y2 + 2.0*z2*x2;
//		float k4 = x2 - y2 + z2;
//
//		w.x = p.x +  64.0*x*y*z*(x2-z2)*k4*(x4-6.0*x2*z2+z4)*k1*k2;
//		w.y = p.y + -16.0*y2*k3*k4*k4 + k1*k1;
//		w.z = p.z +  -8.0*y*k4*(x4*x4 - 28.0*x4*x2*z2 + 70.0*x4*z4 - 28.0*x2*z2*z4 + z4*z4)*k1*k2;
//		#else
//		dz = 8.0*pow(sqrt(m), 7.0)*dz + 1.0;
//		//dz = 8.0*pow(m,3.5)*dz + 1.0;
//
//		float r = length(w);
//		float b = 8.0*acos(w.y/r);
//		float a = 8.0*atan(w.x, w.z);
//		w = p + pow(r, 8.0) * vec3(sin(b)*sin(a), cos(b), sin(b)*cos(a));
//		#endif
//
//		trap = min(trap, vec4(abs(w), m));
//
//		m = dot(w, w);
//		if (m > 256.0)
//		break;
//	}
//
////	resColor = vec4(m, trap.yzw);
//
//	return createSdf(0.25*log(m)*sqrt(m)/dz);
}

#endif // RTK_USE_MANDELBULB
#ifdef RTK_USE_BOX_FRAME_SMOOTH

Sdf gen_boxFrameSmooth(vec3 p, vec3 transform, vec3 size, float radius, float smoothing) {
	p -= transform;
	// front quad frame
	float dist = fQuadFrameSmooth(
		p - vec3(0, 0, 0.5 * size.z),
		size.xy,
		radius, smoothing);
	// back quad frame
	dist = fOpUnionSoft(dist, fQuadFrameSmooth(
		p + vec3(0, 0, 0.5 * size.z),
		size.xy,
		radius, smoothing), smoothing);
	// top left front-back
//	dist = fOpUnionSoft(dist, fCapsule(p,
//		size * vec3(-0.5, 0.5, -0.5),
//		size * vec3(-0.5, 0.5, 0.5),
//		radius), smoothing);
//	// top right front-back
//	dist = fOpUnionSoft(dist, fCapsule(p,
//		size * vec3(0.5, 0.5, -0.5),
//		size * vec3(0.5, 0.5, 0.5),
//		radius), smoothing);
	// bottom left front-back
//	dist = fOpUnionSoft(dist, fCapsule(p,
//		size * vec3(-0.5, -0.5, -0.5),
//		size * vec3(-0.5, -0.5, 0.5),
//		radius), smoothing);
	// bottom right front-back
//	dist = fOpUnionSoft(dist, fCapsule(p,
//		size * vec3(0.5, -0.5, -0.5),
//		size * vec3(0.5, -0.5, 0.5),
//		radius), smoothing);
	return createSdf(dist);
}

#endif // RTK_USE_BOX_FRAME_SMOOTH

#ifdef RTK_USE_HEX_PRISM

float sdHexPrism( vec3 p, vec2 h )
{
	const vec3 k = vec3(-0.8660254, 0.5, 0.57735);
	p = abs(p);
	p.xy -= 2.0*min(dot(k.xy, p.xy), 0.0)*k.xy;
	vec2 d = vec2(
		length(p.xy-vec2(clamp(p.x,-k.z*h.x,k.z*h.x), h.x))*sign(p.y-h.x),
		p.z-h.y );
	return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}

#endif // RTK_USE_HEX_PRISM

#ifdef RTK_USE_TRI_PRISM

float sdTriPrism( vec3 p, vec2 h )
{
  vec3 q = abs(p);
  return max(q.z-h.y,max(q.x*0.866025+p.y*0.5,-p.y)-h.x*0.5);
}

#endif // RTK_USE_TRI_PRISM

#ifdef RTK_USE_LINK
float sdLink( vec3 p, float le, float r1, float r2 )
{
  vec3 q = vec3( p.x, max(abs(p.y)-le,0.0), p.z );
  return length(vec2(length(q.xy)-r1,q.z)) - r2;
}
#endif // RTK_USE_LINK

#ifdef RTK_USE_HELIX
//Eiffie
float sdHelix(vec3 p, float r1, float r2, float m, float dualSpread) {
	float halfm = m*.5,
		b = mod(p.y, PI*m) - PI*halfm,
		a = abs(atan(p.x, p.z) * halfm - b);
	if (a > PI*halfm) a = PI*m - a;

	//optimisation from Shane
	p.xy = vec2(length(p.xz) - r1, a);
	p.x = abs(p.x) - dualSpread;
	return length(p.xy) - r2;
}
#endif // RTK_USE_HELIX

#endif // RTK_GENERATORS
