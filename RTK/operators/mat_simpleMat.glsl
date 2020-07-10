Sdf thismap(vec3 p, Context ctx) {
	Sdf res = inputOp1(p, ctx);
	res.y = THIS_matID;
	res.refract = false;
	res.reflect = false;
	return res;
}

vec3 THIS_getColor(MatInputs matIn, vec3 lightPos, vec3 lightColor) {
	vec3 col = THIS_Color;

	float ks= THIS_Ks;
	// // lighting
	float sky = 0.5 + 0.5*matIn.n.y*1;
	float fre = clamp( 1.0 + dot(matIn.n,matIn.rd), 0.0, 1.0 );
	vec3 lightDir = normalize(lightPos-matIn.pos);

	// float spe = pow(max( dot(-rd,n),0.0),); //looks nice but doesn't react to light.
	float spe = pow(max(dot(matIn.rd, reflect(lightDir,matIn.n)),0),THIS_Shininess); //not sure about this
	// lights
	vec3 lin  = vec3(0.0);
	     lin += 3.0*vec3(0.7,0.80,1.00)*sky*matIn.occ;
	     lin += 1.0*fre*vec3(1.2,0.70,0.60)*(0.1+0.9*matIn.occ);
	col.rgb += 0.3*ks*4.0*vec3(0.7,0.8,1.00)*smoothstep(0.0,0.2,matIn.ref.y)*(0.05+0.95*pow(fre,5.0))*(0.5+0.5*matIn.n.y)*matIn.occ;
	col.rgb += 4.0*ks*1.5*spe*matIn.occ*col.x;
	col.rgb += 2.0*ks*1.0*pow(spe,8.0)*matIn.occ*col.x;
	col.rgb = col.rgb* lin * lightColor;

	return col;
}
