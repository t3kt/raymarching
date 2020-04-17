# materialCore

Constructs a definition for an RTK material OP.

A material takes in one input definition and adds its own which uses that input.

This is a specialized type of a filter. It includes support for adding a `materialParagraph`, which is a block of code that is run separate from the SDF, in the section of the shader that determines color and lighting.


Like the filter OP, it does *not* modify the input definitions. Instead adds a new one that refers to the functions defined by the inputs.

See `definitionCore` for details.