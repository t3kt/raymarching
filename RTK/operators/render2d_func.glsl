Sdf thismap(vec2 p){
	Sdf res = inputOp1(p, defaultContext());
	res.y = @matID;
	return res;
}
Sdf thismap(vec2 p, Context ctx){
	Sdf res = inputOp1(p, ctx);
	res.y = @matID;
	return res;
}
vec4 getBackgroundColor(Sdf res) {
	float d = res.x;
	vec4 col = THIS_Color1;
	col.rgb *= 1.0 - exp(-3.0*abs(d));
	col.rgb *= 0.8 + 0.5*cos(350.0*d);
	col.rgb = mix( col.rgb, vec3(1.0), 1.0-smoothstep(0.0,THIS_Edgethickness/2.0,abs(d)) );
	
	return col;
}
vec4 getDefaultColor(Sdf res) {
	float d = res.x;
	vec4 col = THIS_Color1;
	col.rgb *= 1.0 - exp(-3.0*abs(d));
	col.rgb *= 0.8 + 0.2*cos(150.0*d);
	col.rgb = mix( col.rgb, vec3(1.0), 1.0-smoothstep(0.0,THIS_Edgethickness/2.0,abs(d)) );
	
	return col;
}
vec4 THIS_getColor(Sdf res) {
	return getDefaultColor(res);
}
		


	
	