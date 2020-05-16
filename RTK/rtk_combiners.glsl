#ifndef RTK_COMBINERS
#define RTK_COMBINERS

Sdf comb_diffColumns(vec3 p, Sdf res1, Sdf res2, float radius, float num){
	float d = fOpDifferenceColumns(res1.x, res2.x, radius, num);
	res1.x = d;
	return res1;
}

Sdf comb_unionColumns(vec3 p, Sdf res1, Sdf res2, float radius, float num){
	float d = fOpUnionColumns(res1.x, res2.x, radius, num);
	res1.x = d;
	return res1;
}

Sdf comb_intersectColumns(vec3 p, Sdf res1, Sdf res2, float radius, float num){
	float d = fOpIntersectionColumns(res1.x, res2.x, radius, num);
	res1.x = d;
	return res1;
}

Sdf comb_unionStairs(vec3 p, Sdf res1, Sdf res2, float radius, float num){
	float d = fOpUnionStairs(res1.x, res2.x, radius, num);
	res1.x = d;
	return res1;
}

Sdf comb_intersectStairs(vec3 p, Sdf res1, Sdf res2, float radius, float num){
	float d = fOpIntersectionStairs(res1.x, res2.x, radius, num);
	res1.x = d;
	return res1;
}

Sdf comb_diffStairs(vec3 p, Sdf res1, Sdf res2, float radius, float num){
	float d = fOpDifferenceStairs(res1.x, res2.x, radius, num);
	res1.x = d;
	return res1;
}

Sdf comb_pipe(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpPipe(res1.x, res2.x, radius);
	res1.x = d;
	return res1;
}

Sdf comb_unionRound(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpUnionRound (res1.x, res2.x, radius);
	res1.x = d;
	return res1;
}

Sdf comb_intersectRound(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpIntersectionRound (res1.x, res2.x, radius);
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

Sdf comb_unionChamfer(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpUnionChamfer(res1.x, res2.x, radius);
	res1.x = d;
	return res1;
}

Sdf comb_diffChamfer(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpDifferenceChamfer(res1.x, res2.x, radius);
	res1.x = d;
	return res1;
}

Sdf comb_engrave(vec3 p, Sdf res1, Sdf res2, float radius){
	float d = fOpEngrave(res1.x, res2.x, radius);
	res1.x = d;
	return res1;
}

Sdf comb_groove(vec3 p, Sdf res1, Sdf res2, float radius1, float radius2){
	float d = fOpGroove(res1.x, res2.x, radius1, radius2);
	res1.x = d;
	return res1;
}

Sdf comb_tongue(vec3 p, Sdf res1, Sdf res2, float radius1, float radius2){
	float d = fOpTongue(res1.x, res2.x, radius1, radius2);
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

#define comb_subtraction  comb_simpleDiff

#endif // RTK_COMBINERS
