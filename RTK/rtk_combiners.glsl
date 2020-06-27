#ifndef RTK_COMBINERS
#define RTK_COMBINERS

Sdf comb_diffColumns(vec3 p, Sdf res1, Sdf res2, float radius, float num) {
	res1.x = fOpDifferenceColumns(res1.x, res2.x, radius, num);
	return res1;
}

Sdf comb_unionColumns(vec3 p, Sdf res1, Sdf res2, float radius, float num) {
	res1.x = fOpUnionColumns(res1.x, res2.x, radius, num);
	return res1;
}

Sdf comb_intersectColumns(vec3 p, Sdf res1, Sdf res2, float radius, float num) {
	res1.x = fOpIntersectionColumns(res1.x, res2.x, radius, num);
	return res1;
}

Sdf comb_unionStairs(vec3 p, Sdf res1, Sdf res2, float radius, float num) {
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/radius, 0., 1.);
	res1.x = fOpUnionStairs(res1.x, res2.x, radius, num);
	res1.material2 = res2.y;
	res1.interpolant = h;
	return res1;
}

Sdf comb_intersectStairs(vec3 p, Sdf res1, Sdf res2, float radius, float num) {
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/radius, 0., 1.);
	res1.x = fOpIntersectionStairs(res1.x, res2.x, radius, num);
	res1.material2 = res2.y;
	res1.interpolant = h;
	return res1;
}

Sdf comb_diffStairs(vec3 p, Sdf res1, Sdf res2, float radius, float num) {
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/radius, 0., 1.);
	res1.x = fOpDifferenceStairs(res1.x, res2.x, radius, num);
	res1.material2 = res2.y;
	res1.interpolant = h;
	return res1;
}

Sdf comb_pipe(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpPipe(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_unionRound(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpUnionRound(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_intersectRound(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpIntersectionRound (res1.x, res2.x, radius);
	return res1;
}

Sdf comb_diffRound(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpDifferenceRound (res1.x, res2.x, radius);
	return res1;
}

Sdf comb_intersectChamfer(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpIntersectionChamfer(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_unionChamfer(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpUnionChamfer(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_diffChamfer(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpDifferenceChamfer(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_engrave(vec3 p, Sdf res1, Sdf res2, float radius) {
	res1.x = fOpEngrave(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_groove(vec3 p, Sdf res1, Sdf res2, float radius1, float radius2) {
	res1.x = fOpGroove(res1.x, res2.x, radius1, radius2);
	return res1;
}

Sdf comb_tongue(vec3 p, Sdf res1, Sdf res2, float radius1, float radius2) {
	res1.x = fOpTongue(res1.x, res2.x, radius1, radius2);
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
	res.material2 = res2.y;
	res.interpolant = h;
	// float d = opSmoothUnionM(res1.x , res2.x, amount );
	// float m = opSmoothUnion(res1.y , res2.y, amount );
	return res;//opSmoothUnionM(res1 , res2, amount );
}

Sdf comb_smoothIntersect(vec3 p, Sdf res1, Sdf res2, float amount){
	Sdf res = res1;
	float h = clamp(0.5 - 0.5*(res2.x-res1.x)/amount, 0., 1.);
	res.x = mix(res2.x, res1.x, h) + amount*h*(1.0-h);
	res.material2 = res2.y;
	res.interpolant = h;
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
