vec4 thismap(vec3 p, Context ctx) {
	return texture(THIS_texture, (p.PLANE + THIS_Offset) / THIS_Scale);
}
