# RTK
RTK is a TouchDesigner framework for constructing raymarching shaders using COMP networks.

It was originally derived from https://github.com/hrtlacek/TDraymarchToolkit, but has since been rewritten.

The goal of RTK is to be able to use a network of connected OPs to construct a shader, using raymarching and signed distance functions.

In a sense, it's an attempt to create a new class of OP, whose output is a shader, rather than text, image, geometry, etc.
The term `ROP` or `RTK OP` refers to one of these operators.
