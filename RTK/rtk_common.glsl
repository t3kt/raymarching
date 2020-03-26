
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






float hash1( float n )
{
    return fract(sin(n)*43758.5453123);
}

float hash1( in vec2 f )
{
    return fract(sin(f.x+131.1*f.y)*43758.5453123);
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

