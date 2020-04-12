# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def _getModeParams(modes: 'DAT', row: int):
	return [
		'@' + modes[0, col].val
		for col in range(3, modes.numCols)
		if modes[row, col] == '1'
	]

def buildOptimizedBody(modes: 'DAT', modeIndex: int, commonParams: 'list'):
	params = list(commonParams or []) + _getModeParams(modes, modeIndex + 1)
	return '\treturn {}({});'.format(modes[modeIndex + 1, 'function'].val, ','.join(params))

def buildUnoptimizedBody(modes: 'DAT', commonParams: 'list', modeParamName: str, defaultExpr: str):
	commonParams = list(commonParams or [])
	body = '\tswitch (int(@{})) {{\n'.format(modeParamName)
	for row in range(1, modes.numRows):
		params = commonParams + _getModeParams(modes, row)
		body += '\t\tcase {}: return {}({});\n'.format(
			row,
			modes[row, 'function'].val,
			','.join(params)
		)
	body += '\t\tdefault: return {};\n\t}}'.format(defaultExpr)
	return body
