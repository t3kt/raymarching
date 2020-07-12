# Writing ROPs

Each `ROP` provides a block of function definition code, and potentially other types of blocks of code. The `definitionCore` is responsible for processing those code blocks, replacing placerholders with values for the specific `ROP` instance.

The name `thismap` is replaced with a full name for the `ROP`, which is generally used for the `ROP`'s main function name. The prefix `THIS_` is replaced with a unique prefix for that instance, which is used to refer to parameters of the `ROP` instance.

```glsl
// A sphere, with parameters Transformx, Transformy, Radius
Sdf thismap(vec3 p, Context ctx) {
	return createSdf(length(p - THIS_Transform)-THIS_Radius);
}
```
