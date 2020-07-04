Sdf thismap(vec2 p, Context ctx) {
    vec2 d = abs(p - THIS_Translate)-THIS_Scale;
    return createSdf(length(max(d,0.0)) + min(max(d.x,d.y),0.0));
}
