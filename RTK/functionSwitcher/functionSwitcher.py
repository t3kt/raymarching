# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def _getModeParams(modes: 'DAT', row: int, prefix: str = ''):
	return [
		prefix + modes[0, col].val
		for col in range(3, modes.numCols)
		if modes[row, col] == '1'
	]

def buildFunction(template: str):
	modes = op('modes')
	commonParams = parent().par.Commonparams.eval().split(' ')

	if parent().par.Optimize:
		modeIndex = int(parent().par.Modeindex)
		params = list(commonParams or []) + _getModeParams(modes, modeIndex + 1, '@')
		body = '\treturn {}({});'.format(modes[modeIndex + 1, 'function'].val, ','.join(params))
	else:
		modeParamName = parent().par.Modeparamname.eval()
		defaultExpr = parent().par.Defaultexpr.eval()
		body = '\tswitch (int(@{})) {{\n'.format(modeParamName)
		for row in range(1, modes.numRows):
			params = commonParams + _getModeParams(modes, row, '@')
			body += '\t\tcase {}: return {}({});\n'.format(
				row,
				modes[row, 'function'].val,
				','.join(params)
			)
		body += '\t\tdefault: return {};\n\t}}'.format(defaultExpr)
	return template.replace('BODY', body)

def getOpParamList():
	modes = op('modes')
	if parent().par.Optimize:
		return _getModeParams(modes, parent().par.Modeindex + 1)
	else:
		return [parent().par.Modeparamname.eval()] + [
			modes[0, col].val
			for col in range(3, modes.numCols)
		]
