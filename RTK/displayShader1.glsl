// uniform float params[100];

#ifndef LIGHT_COUNT
#define LIGHT_COUNT 5
#endif
uniform vec3 lights[LIGHT_COUNT];

uniform vec2 iResolution;
uniform float iTime;
uniform vec3 camPos;
uniform float FOV;
uniform vec3 camRot;
uniform float lensPar;
uniform float gridOffset; 

// const float PI = 3.1415926535897932384626433832795;
// const float PHI = 1.6180339887498948482045868343656;

out vec4 fragColor;

#define saturate(x) clamp(x, 0, 1)

Sdf map( vec3 q )
{
    Sdf res = thismap(q);
    res.x *= 0.5;
    return res;//vec2(d, 11);
}

Sdf opU(Sdf d1, Sdf d2){
	return (d1.x<d2.x)? d1:d2;
}

vec3 forwardSF( float i, float n)
{
    float phi = 2.0*PI*fract(i/PHI);
    float zi = 1.0 - (2.0*i+1.0)/n;
    float sinTheta = sqrt( 1.0 - zi*zi);
    return vec3( cos(phi)*sinTheta, sin(phi)*sinTheta, zi);
}

float calcAO( in vec3 pos, in vec3 nor, in vec2 pix )
{
    float ao = 0.0;
    for( int i=0; i<64; i++ )
    {
        vec3 ap = forwardSF( float(i), 64.0 );
        ap *= sign( dot(ap,nor) ) * hash1(float(i));
        ao += clamp( map( pos + nor*0.05 + ap*0.2 ).x*64.0, 0.0, 1.0 );
    }
    ao /= 64.0;

    return clamp( ao*ao, 0.0, 1.0 );
}

float calcAO2( in vec3 pos, in vec3 nor, in vec2 pix )
{
    float ao = 0.0;
    for( int i=0; i<32; i++ )
    {
        vec3 ap = forwardSF( float(i), 32.0 );
        ap *= sign( dot(ap,nor) ) * hash1(float(i));
        ao += clamp( map( pos + nor*0.05 + ap*0.2 ).x*100.0, 0.0, 1.0 );
    }
    ao /= 32.0;

    return clamp( ao, 0.0, 1.0 );
}



vec3 calcNormal( in vec3 pos )
{
    vec2 e = vec2(1.0,-1.0)*0.5773*0.005;
    return normalize( e.xyy*map( pos + e.xyy ).x + 
					  e.yyx*map( pos + e.yyx ).x + 
					  e.yxy*map( pos + e.yxy ).x + 
					  e.xxx*map( pos + e.xxx ).x );	
}


// http://iquilezles.org/www/articles/checkerfiltering/checkerfiltering.htm
float checkersGradBox( in vec2 p )
{
    // filter kernel
    vec2 w = fwidth(p) + 0.001;
    // analytical integral (box filter)
    vec2 i = 2.0*(abs(fract((p-0.5*w)*0.5)-0.5)-abs(fract((p+0.5*w)*0.5)-0.5))/w;
    
    // xor pattern
    // return 0.5 - 0.5*i.x*i.y+smoothstep(fract(p.x), 0.0, 0.1)-smoothstep(fract(p.x), 0.2, 1);                  
    p*= 1.;
    float coarse = step(fract(p.x), 0.55)-step(fract(p.x), 0.5)+step(fract(p.y), 0.55)-step(fract(p.y), 0.5);
    p*= 3;
    float fine = step(fract(p.x), 0.55)-step(fract(p.x), 0.5)+step(fract(p.y), 0.55)-step(fract(p.y), 0.5);

    return coarse+fine*0.5;//step(fract(p.x), 0.55)-step(fract(p.x), 0.5)+step(fract(p.y), 0.55)-step(fract(p.y), 0.5);
}
// vec2 castRay( in vec3 ro, in vec3 rd, float renderDepth )
// {
//     float tmin = 0.0010;
//     // float tmax = 70.0;
//    float tmax = min(70.0, renderDepth);
//     float t = tmin;
//     float m = -2.0;
//     for( int i=0; i<pow(2,10); i++ )
//     {
//         float precis = 0.0004*t;
//         Sdf res = map( ro+rd*t );
//         res = opU(res, distGrid(ro+rd*t, gridOffset)); // draw distance grid plane
//         if( res.x<precis || t>tmax ) break;
//         t += res.x;
//         m = res.y;
//     }

//     if( t>tmax ) m=-1.0;
//     return vec2( t, m);
// }

Sdf castRay( in vec3 ro, in vec3 rd, float renderDepth)
{
    float tmin = 0.1;
    float tmax = min(70.0, renderDepth);
   
    float t = tmin;
    float m = -2.0;
    float material2 = 0;
    float interpolant = 0;
    float ior = 1;
    bool refract = false;
    bool reflect = false;
    vec3 newPos = vec3(0);
    for( int i=0; i<pow(2,10); i++ )
    {
	    float precis = 0.0004*t;
        newPos = ro+rd*t;

	    Sdf res = map( newPos );
	    res = opU(res, distGrid(ro+rd*t, gridOffset)); // draw distance grid plane
        refract = res.refract;
        reflect = res.reflect;
        material2 = res.material2;
        interpolant = res.interpolant;
        ior = res.ior;

        if( res.x<precis || t>tmax) break;
        t += res.x;
	    m = res.y;
        
        if(abs(newPos.x)>limitBox.x||abs(newPos.y)>limitBox.y||abs(newPos.z)>limitBox.z){
            m = -1;
            break;
        }

    }

    if( t>tmax ) {
        m=-1.0;
        refract = false;
        reflect = false;
        interpolant = 0;
        ior = 1;
    }

    Sdf result;
    result.x = t;
    result.y = m; 
    result.refract =refract;
    result.reflect =reflect;
    result.material2 =material2;
    result.interpolant =interpolant;
    result.ior =ior;

    return result; 
}


float castShadow(vec3 ro, vec3 rd){
    float res = 1;
    float t = 0.8;
    for (int i=0;i<50; i++){
        vec3 pos = ro + rd*t;
        float h = map(pos).x;
        res = min(res,0.8*h/t);
        // if(t>0.01) break;
        h+=t;
        if(t>10) break;

    }

    return clamp(res, 0., 1.);
}


vec4 getMat2(float m, vec3 pos, vec3 n, vec3 ref, vec3 refraction, vec3 eye, float occ, float occ2, float t, vec3 rd){
    vec4 col = vec4(vec3(0.5),1);
    vec3 sunDir = normalize(vec3(0.8,0.3,0.6));
// ======= overlapped 'material', so alpha = 0
    if (m==-2){ 

        vec4 col = vec4(0);
        return col;
    }

// ========checkerboard material
    if( m==1 )
        {
            
            float f = checkersGradBox( pos.xz +pos.xy);
            col.rgb = 0.3 + f*vec3(0.7);
            float sunShadow = smoothstep(castShadow(pos+n*0.001, 1*sunDir), 0.0, 0.05);    
            col.rgb *= 0.5+sunShadow*0.5;
        }
// ========Standard Gray material
    if (m==2){
    vec3 mate = vec3(0.38);
    vec3 sunColor = vec3(5.8,4.0,3.5);
    vec3 skyColor = vec3(0.5,0.8,0.9);
    float sunDiffuse = clamp(dot(n,sunDir), 0, 1.);
    float sunShadow = smoothstep(castShadow(pos+n*0.001, sunDir), 0.0, 0.05);
    float skyDiffuse = clamp(0.5+0.5*dot(n,vec3(0,1,0)), 0, 1);
    float sunSpec = pow(max(dot(-rd,n),0.),5)*0.5;
    vec3 col = mate *sunColor*sunDiffuse*sunShadow;
    col += mate*skyColor*skyDiffuse;
    col += mate*sunColor*sunSpec;
    col *= mix(vec3(0.5,0.5,0.5), vec3(1.0,1.0,1.0)*1.5, occ*1.);


    return vec4(col,1);

}

// ==========Grid Material
    if (m==10){ 
        float notGrid = map(pos).x;
        if (notGrid > 0.1){
            vec4 col = vec4(1,1,1,1);
            float lines = saturate(abs(fract(notGrid*0.5)*1-0.9)*10)*1.8;//vec4(0,1,0,1);
            lines += clamp(t-1,0,0.5);
            col.rgb *= lines;
            float sunShadow = smoothstep(castShadow(pos+n*0.001, 1*sunDir), 0.0, 0.05);    
            col.rgb *= 0.5+sunShadow*0.5;
            return col;
        }

    }






// ===========Additional Material is inserted here===================
// #include <materialParagraph>
// 
// 
// 
// 
// 
// 
// 
// ==================================================================







    return col;
}

vec4 getMat(Sdf res, vec3 pos, vec3 n, vec3 ref, vec3 refraction, vec3 eye, float occ, float occ2, float t, vec3 rd){
	float m = res.y;
    if (res.interpolant==0){
        return getMat2(floor(m), pos, n, ref, refraction, eye, occ, occ2, t, rd);
    }
    else{
        vec4 c1 = getMat2(m, pos, n, ref, refraction, eye, occ, occ2, t, rd);
        vec4 c2 = getMat2(res.material2, pos, n, ref, refraction, eye, occ, occ2, t, rd);
        // float k = 1;
        vec4 col = mix( c1, c2, res.interpolant );// - k*res.interpolant*(1.0-res.interpolant);
        // vec4 col = mix(c1,c2,res.interpolant);//vec4(1,0,0,1);
        return col;
    }
}


float castInside(vec3 ro, vec3 rd){
    float res = 0.1;
    float t = 1;
    for (int i=0;i<70; i++){
        vec3 pos = ro + rd*t;
        float h = map(pos).x*-1;

        // res = min(res,0.8*h/t);
        // if(t<0.01) break;
        t+=h;
        res = t;
        // if(t>50) break;
        if(res<0) break;

    }

    return res;
}



void main()
{



vec2 fragCoord = vUV.st*iResolution.xy;
    vec2 p = (-iResolution.xy+2.0*fragCoord.xy)/iResolution.y;
    vec2 q = fragCoord/iResolution.xy;
    float renderDepth = texture(sTD2DInputs[0], vUV.st).r;
    // vec2 m = vec2(0.5);

    //-----------------------------------------------------
    // camera
    //-----------------------------------------------------
    float aspect = iResolution.x/iResolution.y;
    float screenWidth = 2*(aspect);
    float distanceToScreen = (screenWidth/2)/tan(FOV/2)*1;


    vec3 ro = camPos;
    vec3 ta = camPos+vec3(0,0,-1);
    // camera matrix
    vec3 ww = normalize( ta - ro );
    vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0) ) );
    vec3 vv = normalize( cross(uu,ww));

    // create view ray
    mat3 camRotMatX = TDRotateOnAxis(camRot.x,vec3(1,0,0));
    mat3 camRotMatY = TDRotateOnAxis(camRot.y,vec3(0,1,0));
    mat3 camRotMatZ = TDRotateOnAxis(camRot.z,vec3(0,0,1));
    vec3 rd = normalize( p.x*uu + p.y*vv + distanceToScreen*ww) *camRotMatX*camRotMatY*camRotMatZ;

    // vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );


    //-----------------------------------------------------
    // render
    //-----------------------------------------------------

    vec3 col = vec3(0.07)*clamp(1.0-length(q-0.5),0.0,1.0);

    // raymarch
    // vec2 res = castRay(ro,rd);
    Sdf res = castRay(ro,rd, renderDepth);
    float alpha = 0;
    float t = res.x;
    float mat = res.y;
    if( t>0.0 )
    {
    	if (mat <= 0){
    		vec3 col =  vec3(0);
    	}
    	else{

        vec3 pos = ro + t*rd;
        vec3 nor = calcNormal(pos);
        vec3 ref = reflect( rd, nor );
        vec3 sor = nor;

        float occ = calcAO( pos, nor, fragCoord ); 
        float occ2 = calcAO2( pos, nor, fragCoord );

        // =============reflections====================== 
        vec3 roRefl = pos+nor*0.0001;
        vec3 rdRefl = ref;
        Sdf resRef = castRay(roRefl, rdRefl, 100);
        float tRefl = resRef.x;
        vec3 posRefl = roRefl + tRefl*rdRefl;

        vec3 norRefl = calcNormal(posRefl);
        vec3 colRefl = getMat(resRef, posRefl, norRefl, vec3(0),vec3(0), camPos, occ, occ2, tRefl, rdRefl).rgb;
        // ==============================================

        //================Refractions============================
        vec3 refrCol = vec3(0);
        if (res.refract){
        float IOR = res.ior;//1.1;
        vec3 insideRd = refract(rd,nor, IOR);
        float insideDist = castInside(pos+rd*0.1,insideRd);
        vec3 posRefrOut = pos+insideRd*insideDist*1.;
        vec3 norOut = calcNormal(posRefrOut);
        vec3 outSideRd = refract(insideRd, -1*norOut, 1./IOR);
        Sdf resRefr = castRay(posRefrOut+rd*0.5,outSideRd,70);
        float tRefr = resRefr.x;
        vec3 posFin = posRefrOut+outSideRd*tRefr;
        vec3 norRefr = calcNormal(posFin);
        refrCol = getMat(resRefr, posFin, norRefr, vec3(0), vec3(0),camPos, occ, occ2, tRefr, outSideRd).rgb;
        float travelAtten = clamp(1-tRefr*0.05, 0, 1);
        refrCol *= travelAtten;
}

        //=======================================================

        vec4 colA = getMat(res, pos, nor, colRefl, refrCol,camPos, occ, occ2, t, rd );//*1+colRefl*0.5;
        col = colA.rgb;
        alpha = colA.a;
        // float ar = clamp(1.0-0.8*length(q-pos),0.0,1.0);
        // col = mix( col, vec3(2.1,2.0,1.2), ar);
        col  *= 0.3;
        


        
        // float ks= 0.3;
        // // // lighting
        // float sky = 0.5 + 0.5*nor.y;
        // float fre = clamp( 1.0 + dot(nor,rd), 0.0, 1.0 );
        // float spe = pow(max( dot(-rd,nor),0.0),8.0);
        // // lights
        // vec3 lin  = vec3(0.0);
        //      lin += 3.0*vec3(0.7,0.80,1.00)*sky*occ;
        //      lin += 1.0*fre*vec3(1.2,0.70,0.60)*(0.1+0.9*occ);
        // col += 0.3*ks*4.0*vec3(0.7,0.8,1.00)*smoothstep(0.0,0.2,ref.y)*(0.05+0.95*pow(fre,5.0))*(0.5+0.5*nor.y)*occ;
        // col += 4.0*ks*1.5*spe*occ*col.x;
        // col += 2.0*ks*1.0*pow(spe,8.0)*occ*col.x;
        // col = col* lin;

        // col *= 2.6*exp(-0.2*t);
    }}

    col = pow(col,vec3(0.4545));

    col = pow( col, vec3(1.0,1.0,1.4) ) + vec3(0.0,0.02,0.14);

    col += (1.0/255.0)*hash1( fragCoord );

    col *= clamp(alpha, 0,1);


    
    // vec4 color = vec4(1.0);
    fragColor = TDOutputSwizzle(vec4(col,alpha));
}
