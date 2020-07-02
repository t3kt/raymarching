// vec4 getMat(float m, vec3 pos, vec3 n, vec3 ref,  vec3 refraction, vec3 eye, float occ, float occ2, float t, vec3 rd)		
// vec4 col = vec4(vec3(0.5),1);
col.rgb = THIS_Color;
vec3 uv = (pos * rotateMatrix(radians(THIS_Rotate)) / THIS_Scale) - THIS_Offset;
uv = mod(uv, vec3(1));
col.rgb += texture(THIS_texture, uv.PLANE_PARTS).rgb;
vec3 lightPos = lights[0];
float ks= THIS_Ks;
// // lighting
float sky = 0.5 + 0.5*n.y*1;
float fre = clamp( 1.0 + dot(n,rd), 0.0, 1.0 );
vec3 lightDir = normalize(lightPos-pos);

// float spe = pow(max( dot(-rd,n),0.0),); //looks nice but doesn't react to light.
float spe = pow(max(dot(rd, reflect(lightDir,n)),0),THIS_Shininess); //not sure about this
// lights
vec3 lin  = vec3(0.0);
     lin += 3.0*vec3(0.7,0.80,1.00)*sky*occ;
     lin += 1.0*fre*vec3(1.2,0.70,0.60)*(0.1+0.9*occ);
col.rgb += 0.3*ks*4.0*vec3(0.7,0.8,1.00)*smoothstep(0.0,0.2,ref.y)*(0.05+0.95*pow(fre,5.0))*(0.5+0.5*n.y)*occ;
col.rgb += 4.0*ks*1.5*spe*occ*col.x;
col.rgb += 2.0*ks*1.0*pow(spe,8.0)*occ*col.x;
col.rgb = col.rgb* lin;

return col;
