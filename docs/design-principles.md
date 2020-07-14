# Design Principles

The two most important properties of the framework (in order of priority) are:
1. Runtime performance
2. Ease of use

Runtime performance refers to how efficiently it can run while rendering, including activities such as changing most parameters and feeding in texture streams. It notably does not include connecting or disconnecting `ROP`s, or changing certain special parameters (including bypassing/enabling, switching between algorithms, swapping axes). These are referred to as "setup" activities.

The chain of definition tables should only be cooked when a setup activity occurs, resulting in modified / added / removed definition rows. General parameter changes or input changes must not cause the definitions to cook. To avoid this, the definition rows do not contain the actual parameter values. Instead, they contain the path to a `CHOP` that contains the parameter values. Texture sources are handled similarly.

While improving the speed of setup activities is also important, runtime performance should not be sacrificed to achieve it. There can be a significant stall time when the shader needs to be rebuilt. Note that this is a significant departure from the original [TDraymarchToolkit](https://github.com/hrtlacek/TDraymarchToolkit), which included a rendering shader inside each `ROP` in order to provide an interactive viewer.

There are a variety of tools that ease of use during setup (including a popup dialog to create new `ROP`s and a `ROP` inspector.

## Readability of Generated Shader

During the development and debugging process, it is important to be able to read through the generated code and examine any compilation errors. There is a trade-off between readability and performance during both setup and runtime. When possible, the systems that build the shaders provide settings that can be used to enable or disable various types of optimizations, such as inlining references to parameter names.
