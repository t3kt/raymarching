#ifndef RTK_COMBINERS
#define RTK_COMBINERS

float fOpUnionStairs(float a, float b, float r, float n, float o) {
	float s = r/n;
	float u = b-r;
	return min(min(a,b), 0.5 * (u + a + abs ((mod (u - a + s + o, 2 * s)) - s)));
}

// We can just call Union since stairs are symmetric.
float fOpIntersectionStairs(float a, float b, float r, float n, float o) {
	return -fOpUnionStairs(-a, -b, r, n, o);
}

float fOpDifferenceStairs(float a, float b, float r, float n, float o) {
	return -fOpUnionStairs(-a, b, r, n, o);
}

Sdf comb_diffColumns(Sdf res1, Sdf res2, float radius, float num) {
	res1.x = fOpDifferenceColumns(res1.x, res2.x, radius, num);
	return res1;
}

Sdf comb_unionColumns(Sdf res1, Sdf res2, float radius, float num) {
	res1.x = fOpUnionColumns(res1.x, res2.x, radius, num);
	return res1;
}

Sdf comb_intersectColumns(Sdf res1, Sdf res2, float radius, float num) {
	res1.x = fOpIntersectionColumns(res1.x, res2.x, radius, num);
	return res1;
}

Sdf comb_unionStairs(Sdf res1, Sdf res2, float radius, float num, float offset) {
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/radius, 0., 1.);
	res1.x = fOpUnionStairs(res1.x, res2.x, radius, num, offset);
	res1.material2 = res2.y;
	res1.interpolant = h;
	return res1;
}

Sdf comb_intersectStairs(Sdf res1, Sdf res2, float radius, float num, float offset) {
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/radius, 0., 1.);
	res1.x = fOpIntersectionStairs(res1.x, res2.x, radius, num, offset);
	res1.material2 = res2.y;
	res1.interpolant = h;
	return res1;
}

Sdf comb_diffStairs(Sdf res1, Sdf res2, float radius, float num, float offset) {
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/radius, 0., 1.);
	res1.x = fOpDifferenceStairs(res1.x, res2.x, radius, num, offset);
	res1.material2 = res2.y;
	res1.interpolant = h;
	return res1;
}

Sdf comb_pipe(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpPipe(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_unionRound(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpUnionRound(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_intersectRound(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpIntersectionRound (res1.x, res2.x, radius);
	return res1;
}

Sdf comb_diffRound(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpDifferenceRound (res1.x, res2.x, radius);
	return res1;
}

Sdf comb_intersectChamfer(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpIntersectionChamfer(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_unionChamfer(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpUnionChamfer(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_diffChamfer(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpDifferenceChamfer(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_engrave(Sdf res1, Sdf res2, float radius) {
	res1.x = fOpEngrave(res1.x, res2.x, radius);
	return res1;
}

Sdf comb_groove(Sdf res1, Sdf res2, float radius1, float radius2) {
	res1.x = fOpGroove(res1.x, res2.x, radius1, radius2);
	return res1;
}

Sdf comb_tongue(Sdf res1, Sdf res2, float radius1, float radius2) {
	res1.x = fOpTongue(res1.x, res2.x, radius1, radius2);
	return res1;
}

Sdf comb_simpleDiff(Sdf res1, Sdf res2){
	Sdf res = res1;
	res.x = max(-res1.x, res2.x);
	return res;//(res1.x>res2.x)? res1:res2;
}

Sdf comb_simpleIntersect(Sdf res1, Sdf res2){
	Sdf res = res1;
	res.x = max(res1.x, res2.x);
	return res;//(res1.x>res2.x)? res1:res2;
}

Sdf comb_simpleUnion(Sdf res1, Sdf res2){
	return (res1.x<res2.x)? res1:res2;

}
Sdf comb_smoothDiff(Sdf res1, Sdf res2, float amount){
	Sdf res = res1;
	float h = clamp(0.5 - 0.5*(res2.x+res1.x)/amount, 0., 1.);
	res.x = mix(res2.x, -res1.x, h) + amount*h*(1.0-h);
	res.material2 = res2.y;
	res.interpolant = h;
	// float d = opSmoothUnionM(res1.x , res2.x, amount );
	// float m = opSmoothUnion(res1.y , res2.y, amount );
	return res;//opSmoothUnionM(res1 , res2, amount );
}

Sdf comb_smoothIntersect(Sdf res1, Sdf res2, float amount){
	Sdf res = res1;
	float h = clamp(0.5 - 0.5*(res2.x-res1.x)/amount, 0., 1.);
	res.x = mix(res2.x, res1.x, h) + amount*h*(1.0-h);
	res.material2 = res2.y;
	res.interpolant = h;
	// float d = opSmoothUnionM(res1.x , res2.x, amount );
	// float m = opSmoothUnion(res1.y , res2.y, amount );
	return res;//opSmoothUnionM(res1 , res2, amount );
}

Sdf comb_smoothUnion(Sdf res1, Sdf res2, float amount){
	// float d = opSmoothUnionM(res1.x , res2.x, amount );
	// float m = opSmoothUnion(res1.y , res2.y, amount );
	return opSmoothUnionM(res1, res2, amount);
}

#define comb_subtraction  comb_simpleDiff

#endif // RTK_COMBINERS
