# Instancing and iteration in ROPs

Similar to the `Copy SOP`'s stamping system, a `ROP` can call its input function multiple times, and can pass information up the chain about which iteration is being evaluated.
There are also cases, such as mirroring, where the input function is called only once, but the iteration number depends on the position being evaluated (such as which side of the mirror the point is on).

Each `ROP` function takes in a `Context` struct as well as a coordinate. In the simplest case, it will merely pass the value along when it calls its input function. In other cases, `ROP`s can modify or replace the context value that they pass to their input function.

# The `Context` struct

```glsl
struct Context {
	int iteration;
	int total;
};
```

