# filterCore

Constructs a definition for an RTK filter OP.

A filter takes in one or two input definitions and adds its own which combines those inputs.

The filter OP does *not* modify the input definitions. Instead adds a new one that refers to the functions defined by the inputs.

See `definitionCore` for details.