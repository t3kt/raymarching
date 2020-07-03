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
	return conversion(inputCode, inputName)

def _scalarToVector(inputCode: str, inputName: str):
	oldName = inputName + '_ORIG'
	outputPart = parent().par.Outputvectorpart.eval()
	if len(outputPart) == 1:
		return _convertWithMacro(
			inputCode, inputName, oldName,
			_fillVectorPart(f'{oldName}(p, ctx)', outputPart))
	else:
		wrapperFunc = 'vec4 {}(vec3 p, Context ctx) {{float v = {}(p, ctx); return {};}}'.format(
			inputName, oldName, _fillVectorPart('v', outputPart))
		return inputCode.replace(inputName, oldName, 1) + wrapperFunc

def _sdfToVector(inputCode: str, inputName: str):
	oldName = inputName + '_ORIG'
	outputPart = parent().par.Outputvectorpart.eval()
	if len(outputPart) == 1:
		return _convertWithMacro(
			inputCode, inputName, oldName,
			_fillVectorPart(f'{oldName}(p, ctx)', outputPart))
	else:
		wrapperFunc = 'vec4 {}(vec3 p, Context ctx) {{float v = {}(p, ctx).x; return {};}}'.format(
			inputName, oldName, _fillVectorPart('v', outputPart))
		return inputCode.replace(inputName, oldName, 1) + wrapperFunc

def _scalarToSdf(inputCode: str, inputName: str):
	oldName = inputName + '_ORIG'
	return _convertWithMacro(
		inputCode, inputName, oldName,
		f'createSdf({oldName}(p, ctx))')

def _vectorToScalar(inputCode: str, inputName: str):
	oldName = inputName + '_ORIG'
	inputPart = parent().par.Inputvectorpart.eval()
	return _convertWithMacro(
		inputCode, inputName, oldName,
		f'({oldName}(p, ctx).{inputPart})')

def _vectorToSdf(inputCode: str, inputName: str):
	oldName = inputName + '_ORIG'
	inputPart = parent().par.Inputvectorpart.eval()
	return _convertWithMacro(
		inputCode, inputName, oldName,
		f'createSdf({oldName}(p, ctx).{inputPart})')

def _sdfToScalar(inputCode: str, inputName: str):
	oldName = inputName + '_ORIG'
	return _convertWithMacro(
		inputCode, inputName, oldName,
		f'({oldName}(p, ctx).x)')

def _convertWithMacro(inputCode: str, inputName: str, oldName: str, expression: str):
	return '\n'.join([
		inputCode.replace(inputName, oldName, 1),
		f'#define {inputName}(p, ctx)  {expression}'
	])

def _fillVectorPart(expression: str, part: str):
	if part == 'x':
		return f'vec4({expression}, 0, 0, 0)'
	elif part == 'y':
		return f'vec4(0, {expression}, 0, 0)'
	elif part == 'z':
		return f'vec4(0, 0, {expression}, 0)'
	elif part == 'w':
		return f'vec4(0, 0, 0, {expression})'
	elif part == 'xyz':
		return f'vec4({expression}, {expression}, {expression}, 0)'
	elif part == 'xyzw':
		return f'vec4({expression}, {expression}, {expression}, {expression})'
	raise Exception(f'Unsupported vector part: {part}')

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
