#ifndef RTK_COMBINERS
#define RTK_COMBINERS

Sdf comb_diffColumns(vec3 p, Sdf res1, Sdf res2, float radius, float num){
	float d = fOpDifferenceColumns(res1.x, res2.x, radius, num);
	res1.x = d;
	return res1;
}

Sdf comb_diffRound(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpDifferenceRound (res1.x, res2.x, radius);
	res1.x = d;
	return res1;
}

Sdf comb_intersectChamfer(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpIntersectionChamfer(res1.x, res2.x, radius);
	res1.x = d;
	return res1;
}

Sdf comb_simpleDiff(vec3 p, Sdf res1, Sdf res2){
	Sdf res = res1;
	res.x = max(-res1.x, res2.x);
	return res;//(res1.x>res2.x)? res1:res2;
}

Sdf comb_simpleIntersect(vec3 p, Sdf res1, Sdf res2){
	Sdf res = res1;
	res.x = max(res1.x, res2.x);
	return res;//(res1.x>res2.x)? res1:res2;
}

Sdf comb_simpleUnion(vec3 p, Sdf res1, Sdf res2){
	return (res1.x<res2.x)? res1:res2;

}
Sdf comb_smoothDiff(vec3 p, Sdf res1, Sdf res2, float amount){
	Sdf res = res1;
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/amount, 0., 1.);
	res.x = mix(res2.x, -res1.x, h) + amount*h*(1.0-h);
	// float d = opSmoothUnionM(res1.x , res2.x, amount );
	// float m = opSmoothUnion(res1.y , res2.y, amount );
	return res;//opSmoothUnionM(res1 , res2, amount );
}

Sdf comb_smoothIntersect(vec3 p, Sdf res1, Sdf res2, float amount){
	Sdf res = res1;
	float h = clamp(0.5 - 0.5*(res2.x-res1.x)/amount, 0., 1.);
	res.x = mix(res2.x, res1.x, h) + amount*h*(1.0-h);
	// float d = opSmoothUnionM(res1.x , res2.x, amount );
	// float m = opSmoothUnion(res1.y , res2.y, amount );
	return res;//opSmoothUnionM(res1 , res2, amount );
}

Sdf comb_smoothUnion(vec3 p, Sdf res1, Sdf res2, float amount){
	// float d = opSmoothUnionM(res1.x , res2.x, amount );
	// float m = opSmoothUnion(res1.y , res2.y, amount );
	return opSmoothUnionM(res1, res2, amount);
}

#endif // RTK_COMBINERS
