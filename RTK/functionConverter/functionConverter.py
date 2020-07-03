# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def _convertFunctionBody(inputCode: str, inputType: str, inputName: str):
	if not inputCode:
		return ''
	outputType = parent().par.Outputfunctype.eval()
	if inputType == outputType:
		return inputCode
	conversion = _conversions.get((inputType, outputType))
	if conversion is None:
		return inputCode
	# #       float FOO(vec3 p, Context ctx) { float whatever = FOO_stuff; return whatever * 5; }
	# # or... #define FOO(p, ctx)  p.x + FOO_stuff
	oldName = inputName + '_ORIG'
	return '\n'.join([
		inputCode.replace(inputName, oldName, 1),
		f'#define {inputName}(p, ctx)  {conversion(oldName)}'
	])

def _scalarToVector(oldName: str):
	return f'vec4({oldName}(p, ctx), 0, 0, 0)'

def _scalarToSdf(oldName: str):
	return f'createSdf({oldName}(p, ctx))'

def _vectorToScalar(oldName: str):
	return f'({oldName}(p, ctx).x)'

def _vectorToSdf(oldName: str):
	return f'createSdf({oldName}(p, ctx).x)'

def _sdfToScalar(oldName: str):
	return f'({oldName}(p, ctx).x)'

def _sdfToVector(oldName: str):
	return f'vec4({oldName}(p, ctx).x, 0, 0, 0)'

_conversions = {
	('scalar', 'field'): _scalarToVector,
	('scalar', 'sdf'): _scalarToSdf,
	('field', 'scalar'): _vectorToScalar,
	('field', 'sdf'): _vectorToSdf,
	('sdf', 'scalar'): _sdfToScalar,
	('sdf', 'field'): _sdfToVector,
}

def buildFunction(dat: 'DAT'):
	dat.copy(dat.inputs[0])
	definition = op('definition_1')
	if not definition.numRows > 1 or not definition[1, 0]:
		return
	dat.text = _convertFunctionBody(
		dat.text,
		definition[1, 'funcType'].val,
		definition[1, 'name'].val)
