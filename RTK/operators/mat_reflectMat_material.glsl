// vec4 getMat(float m, vec3 pos, vec3 n, vec3 ref, vec3 refraction, vec3 eye, float occ, float occ2, float t, vec3 rd)		
// vec4 col = vec4(vec3(0.5),1);
col.rgb = vec3(@Colorx,@Colory,@Colorz);
col.rgb+= texture(@texture, pos.xz*vec2(@Texscalex, @Texscaley)).rgb*@Texamount;
vec3 lightPos = lights[0];
float ks= 0.5;
// // lighting
float sky = 0.5 + 0.5*n.y*1;
float fre = clamp( 1.0 + dot(n,rd), 0.0, 1.0 );
vec3 lightDir = normalize(lightPos-pos);

// float spe = pow(max( dot(-rd,n),0.0),); //looks nice but doesn't react to light.
float spe = pow(max(dot(rd, reflect(lightDir,n)),0),@Shininess); //not sure about this
// lights
vec3 lin  = vec3(0.0);
     lin += 3.0*vec3(0.7,0.80,1.00)*sky*occ;
     lin += 1.0*fre*vec3(1.2,0.70,0.60)*(0.1+0.9*occ);
col.rgb += 0.3*ks*4.0*vec3(0.7,0.8,1.00)*smoothstep(0.0,0.2,ref.y)*(0.05+0.95*pow(fre,5.0))*(0.5+0.5*n.y)*occ;
col.rgb += 4.0*ks*1.5*spe*occ*col.x;
col.rgb += 2.0*ks*1.0*pow(spe,8.0)*occ*col.x;
col.rgb = col.rgb* lin;

vec3 reflContrib = ref*@Reflectionamount*((1-@Fresnel)+(@Fresnel*clamp(1-dot(-rd,n),0,1)));
col.rgb += reflContrib;
// col.rgb *= 2.6*exp(-0.2*t);
// col.rgb += ref*@Reflectionamount*clamp(1-dot(-rd,n),0,1); //pseudo Fresnel

col.rgb += refraction*@Transparency;

return col;

	
	