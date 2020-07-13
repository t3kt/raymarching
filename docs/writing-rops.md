# Writing ROPs

Each `ROP` provides a block of function definition code, and potentially other types of blocks of code. The `definitionCore` is responsible for processing those code blocks, replacing placeholders with values for the specific `ROP` instance.

## Code Transformation

The code is specified in a `DAT`, which is then modified in several ways so it can be used in the `shaderBuilder` to define the function for the `ROP`.

The function (or preprocessor `#define`) is written with the name `thismap`, which then gets replaced with a unique name specific to the `ROP` instance (using its path).

```glsl
Sdf thismap(vec3 p, Context ctx) {
	return createSdf(length(p - vec3(0.5)));
}
```

### Parameters

To refer to the parameters of the `ROP`, use `THIS_` followed by the parameter name. In the case of tuple (multi-part) parameters, the names of the individual parts can be used, as can the name of the tuple itself, which evaluates to a `vecN` of the relevant size.

For example, if a `ROP` has parameters `Translate[xy]`, it could either use `THIS_Translatex` ( a single`float`) or `THIS_Translate` (a `vec2` containing both parts).

```glsl
// A sphere, with parameters Translatex, Translatey, Translatez, Radius
Sdf thismap(vec3 p, Context ctx) {
	return createSdf(length(p - THIS_Translate)-THIS_Radius);
}
```

### Textures

`ROP`s that use textures use a `DAT` table that lists out the name of each texture and the `TOP` path for it. Within the shader code, it can use `THIS_textureName` to refer to a `sampler2D` for that texture.
