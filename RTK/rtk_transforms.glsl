#ifndef RTK_TRANFORMS
#define RTK_TRANFORMS

Sdf trans_elongate(inout vec3 p, inout Sdf input1, vec3 length){
	vec3 h = length;
	vec3 q = p - clamp(p, -h, h);
	return inputOp1(q);
}

Sdf trans_moduloX(inout vec3 p, float size){
	float q = p.x;
	float halfsize = size*0.5;
	float c = floor((q + halfsize)/size);
	q = mod(q + halfsize, size) - halfsize;
	p.x  = q;
	return inputOp1(p);
}

Sdf trans_moduloY(inout vec3 p, float size){
	float q = p.y;
	float halfsize = size*0.5;
	float c = floor((q + halfsize)/size);
	q = mod(q + halfsize, size) - halfsize;
	p.y  = q;
	return inputOp1(p);
}

Sdf trans_moduloZ(inout vec3 p, float size){
	float q = p.z;
	float halfsize = size*0.5;
	float c = floor((q + halfsize)/size);
	q = mod(q + halfsize, size) - halfsize;
	p.z  = q;
	return inputOp1(p);
}

Sdf trans_noise(inout vec3 p, float period, vec3 transform, vec3 scale){
	p += TDPerlinNoise(vec3(p.x*period+transform.x, p.y*period+transform.y, p.z*period+transform.z))*scale;
	return inputOp1(p);
}

Sdf trans_noiseFloat(inout vec3 p, float period, vec3 transform, float scaleX){
	float n = TDPerlinNoise(vec3(p.x*period+transform.x, p.y*period+transform.y, p.z*period+transform.z))*(scaleX);
	Sdf res = inputOp1(p);
	res.x += n;
	return res;//inputOp1(p);
}

Sdf trans_noiseSin(inout vec3 p, float period, vec3 transform, float scale1, float scale2, float scale3){
	Sdf res = inputOp1(p);
	res.x += sin(period*p.x+transform.x)*sin(period*p.y+transform.y)*sin(period*p.z+transform.z)*scale1;
	res.x += sin(period*p.x*2+transform.x)*sin(period*p.y*2+transform.y)*sin(period*p.z*2+transform.z)*scale2;
	res.x += sin(period*p.x*3+transform.x)*sin(period*p.y*3+transform.y)*sin(period*p.z*3+transform.z)*scale3;
	return res;//inputOp1(p);
}

Sdf trans_rotate(inout vec3 p, float amount, vec3 axis){
	mat3 m = TDRotateOnAxis(amount, axis);
	p *= m;
	return inputOp1(p);
}

Sdf trans_round(inout vec3 p, float round){

	// p.x -= @Transformx;
	// p.y -= @Transformy;
	// p.z -= @Transformz;
	Sdf res;
	res = inputOp1(p);
	res.x -= round;
	return res;
}

Sdf trans_scale(inout vec3 p, vec3 scale){
	// Not sure this is correct
	p *= scale;
	Sdf res = inputOp1(p);
	res.x /=length(scale);
	return res;
}

Sdf trans_sine(inout vec3 p, vec3 period, vec3 transform, vec3 scale){
	p.x += sin(p.y*period+transformx)*scalex;
	p.y += sin(p.z*period+transformy)*scaley;
	p.z += sin(p.x*period+transformx)*scalez;

	return inputOp1(p);
}

Sdf trans_textureNoise(inout vec3 p, int texIndex, float period, vec3 scale){
	p += texture(sTD2DInputs[texIndex], (p.xz)*period).rgb*scale;//TDPerlinNoise(vec3(p.x*period+transform.x, p.y*period+transform.y,p.z*period+transform.z))*scale;
	return inputOp1(p);
}

Sdf trans_translate(inout vec3 p, vec3 transform){
	p -= transform;
	return inputOp1(p);
}

#endif // RTK_TRANFORMS
