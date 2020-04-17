# definitionCore

Constructs a definition for an RTK OP.

That definition is passed to the output of the RTK OP that hosts it. Downstream OPs take in that definition and add their own.

The definition is a row in a table, with fields for the OP unique name, function code, parameters, textures, etc.