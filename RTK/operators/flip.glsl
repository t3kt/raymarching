Sdf thismap(vec3 p, Context ctx) {
	vec3 q = p;
	q.AXIS += THIS_Offset;
	q.AXIS *= -1;
	q.AXIS -= THIS_Shift;
	#if defined(THIS_MERGE_none)
	return inputOp1(q, ctx);
	#else
		Sdf res1 = inputOp1(p, ctx);
		Sdf res2 = inputOp1(q, ctx);
		#ifdef THIS_MERGE_smoothUnion
		return comb_smoothUnion(res1, res2, THIS_Mergeradius);
		#else
		return comb_simpleUnion(res1, res2);
		#endif
	#endif
}
