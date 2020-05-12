# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def _getModeParams(modes: 'DAT', row: int, prefix: str = ''):
	return [
		prefix + modes[0, col].val.replace('has', '', 1)
		for col in range(3, modes.numCols)
		if modes[row, col] == '1'
	]

def buildFunction(template: str):
	modes = op('modes')
	commonParams = parent().par.Commonparams.eval().split(' ')
	callPrefix = parent().par.Functioncallprefix.eval()

	if parent().par.Optimize:
		modeIndex = int(parent().par.Modeindex)
		params = list(commonParams or []) + _getModeParams(modes, modeIndex + 1, '@')
		body = '\t{} {}({});'.format(
			callPrefix,
			modes[modeIndex + 1, 'function'].val,
			','.join(params))
	else:
		modeParamName = parent().par.Modeparamname.eval()
		defaultExpr = parent().par.Defaultexpr.eval()
		# body = '\tswitch (int(@{})) {{\n'.format(modeParamName)
		body = 'int mode = int(@{});\n\t'.format(modeParamName)
		for row in range(1, modes.numRows):
			params = commonParams + _getModeParams(modes, row, '@')
			# body += '\t\tcase {}: {} {}({}); break;\n'.format(
			# 	row - 1,
			# 	callPrefix,
			# 	modes[row, 'function'].val,
			# 	','.join(params)
			# )
			body += 'if (mode == {}) {{ {} {}({}); }} else\n\t'.format(
				row - 1,
				callPrefix,
				modes[row, 'function'].val,
				','.join(params)
			)
		# body += '\t\tdefault: {} {}; break;\n\t}}'.format(callPrefix, defaultExpr)
		body += '{{ {} {}; }}\n'.format(callPrefix, defaultExpr)
	if 'BODY();' in template:
		return template.replace('BODY();', body)
	return template.replace('BODY', body)

def getOpParamList():
	modes = op('modes')
	if parent().par.Optimize:
		return _getModeParams(modes, parent().par.Modeindex + 1)
	else:
		return [parent().par.Modeparamname.eval()] + [
			modes[0, col].val.replace('has', '', 1)
			for col in range(3, modes.numCols)
		]
