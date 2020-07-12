
# RTK
RTK is a framework for constructing raymarching shaders using TouchDesigner networks.
It was originally derived from [TDraymarchToolkit](https://github.com/hrtlacek/TDraymarchToolkit), but has since been rewritten.

The goal of RTK is to be able to use a network of connected OPs to construct a shader, using raymarching and signed distance functions.

## RTK Operators
In a sense, it's an attempt to create a new class of OP, whose output is a shader, rather than text, image, geometry, etc.
The term `ROP` or `RTK OP` refers to one of these operators.

### ROP Definitions
Each `ROP` outputs a "definition" which can be used to construct a GLSL function along with all of its dependencies.
A definition is represented as a `DAT` table that has a header row and one or more definition rows, each corresponding to a single `ROP`. The first row after the header is always the definition outputting that table, and the rows below are upstream `ROPs` that feed into it (its dependencies).

### Renderers

Renderers are placed at the end of a chain, and are responsible for parsing the incoming definition and building a complete GLSL shader, and using that shader in a `GLSL Multi TOP` to render a video stream. Renderers are a special category because they are the only type of `ROP` that does not output its definition (though they do have an internal definition).

### Function Types

There are several types of functions that can be constructed using `ROP`s. They are distinguished by their return type and parameter types.

* **SDF**: `Sdf map(vec3 p, Context ctx)`
* **2D SDF**: `Sdf map(vec2 p, Context ctx)`
* **Value field**: `float map(vec3 p, Context ctx)`
* **Vector field**: `vec4 map(vec3 p, Context ctx)`

####  SDFs (signed distance functions) 

These take in a `vec3` position, and return a `Sdf` struct, which contains the distance value, along with other values such as material assignments and settings.

#### 2D SDFs

These are like regular three dimensional `SDF`s but they take in two dimensional positions.

There are 3D `SDF` operators that take in a 2D one and use it to produce a 3D one, such as `extrude` and `revolve`.

#### Value field

These functions take in a `vec3` position and return a single `float` value. For example, the `fieldPointDistance` operator returns the distance between the position and some other point.

Certain **SDF** operators can take secondary inputs with **vector field** functions. For example, the `round` operator can take a second input that it uses to determine how much rounding to apply for a given point in space.

#### Vector field

These are like **value field** functions, but instead of returning a single `float`, they return a `vec4`.


# Design Principles

The two most important properties of the framework (in order of priority) are:
1. Runtime performance
2. Ease of use

Runtime performance refers to how efficiently it can run while rendering, including activities such as changing most parameters and feeding in texture streams. It notably does not include connecting or disconnecting `ROP`s, or changing certain special parameters (including bypassing/enabling, switching between algorithms, swapping axes). These are referred to as "setup" activities.

The chain of definition tables should only be cooked when a setup activity occurs, resulting in modified / added / removed definition rows. General parameter changes or input changes must not cause the definitions to cook. To avoid this, the definition rows do not contain the actual parameter values. Instead, they contain the path to a `CHOP` that contains the parameter values. Texture sources are handled similarly.

While improving the speed of setup activities is also important, runtime performance should not be sacrificed to achieve it. There can be a significant stall time when the shader needs to be rebuilt. Note that this is a significant departure from the original [TDraymarchToolkit](https://github.com/hrtlacek/TDraymarchToolkit), which included a rendering shader inside each `ROP` in order to provide an interactive viewer.

There are a variety of tools that ease of use during setup (including a popup dialog to create new `ROP`s and a `ROP` inspector.
