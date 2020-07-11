float thismap(vec3 p, Context ctx) {
	return length((p - THIS_Translate) / THIS_Scale);
}
