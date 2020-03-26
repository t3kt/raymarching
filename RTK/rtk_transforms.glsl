#ifndef RTK_TRANFORMS
#define RTK_TRANFORMS

vec3 trans_elongate(vec3 p, vec3 length){
	vec3 h = length;
	vec3 q = p - clamp(p, -h, h);
	return q;
}

vec3 trans_moduloX(vec3 p, float size){
	float q = p.x;
	float halfsize = size*0.5;
	float c = floor((q + halfsize)/size);
	q = mod(q + halfsize, size) - halfsize;
	p.x  = q;
	return p;
}

vec3 trans_moduloY(vec3 p, float size){
	float q = p.y;
	float halfsize = size*0.5;
	float c = floor((q + halfsize)/size);
	q = mod(q + halfsize, size) - halfsize;
	p.y  = q;
	return p;
}

vec3 trans_moduloZ(vec3 p, float size){
	float q = p.z;
	float halfsize = size*0.5;
	float c = floor((q + halfsize)/size);
	q = mod(q + halfsize, size) - halfsize;
	p.z  = q;
	return p;
}

vec3 trans_noise(vec3 p, float period, vec3 transform, vec3 scale){
	p += TDPerlinNoise(vec3(p.x*period+transform.x, p.y*period+transform.y, p.z*period+transform.z))*scale;
	return p;
}
//
//vec3 trans_noiseFloat(inout vec3 p, float period, vec3 transform, float scaleX){
//	float n = TDPerlinNoise(vec3(p.x*period+transform.x, p.y*period+transform.y, p.z*period+transform.z))*(scaleX);
//	Sdf res = inputOp1(p);
//	res.x += n;
//	return res;//inputOp1(p);
//}
//
//vec3 trans_noiseSin(inout vec3 p, float period, vec3 transform, float scale1, float scale2, float scale3){
//	Sdf res = inputOp1(p);
//	res.x += sin(period*p.x+transform.x)*sin(period*p.y+transform.y)*sin(period*p.z+transform.z)*scale1;
//	res.x += sin(period*p.x*2+transform.x)*sin(period*p.y*2+transform.y)*sin(period*p.z*2+transform.z)*scale2;
//	res.x += sin(period*p.x*3+transform.x)*sin(period*p.y*3+transform.y)*sin(period*p.z*3+transform.z)*scale3;
//	return res;//inputOp1(p);
//}
//
vec3 trans_rotate(vec3 p, float amount, vec3 axis){
	mat3 m = TDRotateOnAxis(amount, axis);
	p *= m;
	return p;
}

//vec3 trans_round(vec3 p, float round){
//
//	// p.x -= @Transformx;
//	// p.y -= @Transformy;
//	// p.z -= @Transformz;
//	Sdf res;
//	res = inputOp1(p);
//	res.x -= round;
//	return res;
//}
//
//vec3 trans_scale(inout vec3 p, vec3 scale){
//	// Not sure this is correct
//	p *= scale;
//	Sdf res = inputOp1(p);
//	res.x /=length(scale);
//	return res;
//}
//
vec3 trans_sine(vec3 p, float period, vec3 transform, vec3 scale){
	p.x += sin(p.y*period+transform.x)*scale.x;
	p.y += sin(p.z*period+transform.y)*scale.y;
	p.z += sin(p.x*period+transform.x)*scale.z;

	return p;
}

vec3 trans_textureNoise(vec3 p, int texIndex, float period, vec3 scale){
	p += texture(sTD2DInputs[texIndex], (p.xz)*period).rgb*scale;//TDPerlinNoise(vec3(p.x*period+transform.x, p.y*period+transform.y,p.z*period+transform.z))*scale;
	return p;
}

vec3 trans_translate(vec3 p, vec3 transform){
	p -= transform;
	return p;
}

#endif // RTK_TRANFORMS
