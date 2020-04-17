# shaderBuilder

Takes in a set of RTK OP definitions and constructs a shader to render them. It also produces output tables that are used to configure the GLSL Multi TOP where the shader is run.

The shader is composed of several parts, including:

* The hg_sdf library
* RTK libraries
* Definitions for constants based on render settings
* An SDF function from each OP
* Aliases for OP parameters
* Declarations for samplerBuffers used for instancing
* Aliases for textures
* Definitions for materials
* The main rendering code, with material paragraphs injected into it
