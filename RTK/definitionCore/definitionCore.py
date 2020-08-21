import re
from typing import Dict, List, Union

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *
	from RTK.inspector.inspector import Inspector

def buildName():
	d = parent()
	host = d.par.Hostop.eval()
	if not host:
		return ''
	pathParts = host.path[1:].split('/')
	for i in range(len(pathParts)):
		if pathParts[i].startswith('_'):
			pathParts[i] = 'U' + pathParts[i][1:]
	name = '_'.join(pathParts)
	name = re.sub('_+', '_', name)
	if name.startswith('_'):
		name = 'o_' + name
	return name

def _getRegularParams() -> 'List[Par]':
	host = parent().par.Hostop.eval()
	if not host:
		return []
	paramNames = parent().par.Params.eval().strip().split(' ')
	return [
			p
			for p in host.pars(*[pn.strip() for pn in paramNames])
			if p.isCustom and not (p.isPulse and p.name == 'Inspect')
		]

def _getSpecialParamNames():
	return tdu.expand(parent().par.Specialparams.eval())

def buildParamTable(dat: 'DAT'):
	dat.clear()
	host = parent().par.Hostop.eval()
	if not host:
		return
	name = parent().par.Name.eval()
	allParamNames = [p.name for p in _getRegularParams()] + _getSpecialParamNames()
	dat.appendCol([(name + '_' + pn) if pn != '_' else '_' for pn in allParamNames])

def buildParamDetailTable(dat: 'DAT'):
	dat.clear()
	dat.appendRow(['tuplet', 'source', 'size', 'part1', 'part2', 'part3', 'part4'])
	name = parent().par.Name.eval()
	params = _getRegularParams()
	if params:
		processedTupletNames = set()
		for par in params:
			if par.tupletName in processedTupletNames:
				continue
			dat.appendRow(
				[f'{name}_{par.tupletName}', 'param', len(par.tuplet)] + [
					f'{name}_{p.name}' for p in par.tuplet])
			processedTupletNames.add(par.tupletName)
	specialNames = _getSpecialParamNames()
	if specialNames:
		parts = []
		specialIndex = 0

		def addSpecial():
			cleanParts = [p for p in parts if p != '_']
			tupletName = _getTupletName(cleanParts) or f'special{specialIndex}'
			dat.appendRow([f'{name}_{tupletName}', 'special', len(cleanParts)] + [
				f'{name}_{part}' for part in cleanParts
			])

		for specialName in specialNames:
			parts.append(specialName)
			if len(parts) == 4:
				addSpecial()
				parts.clear()
				specialIndex += 1
		if parts:
			addSpecial()

def _getTupletName(parts: List[str]):
	if len(parts) <= 1 or len(parts[0]) <= 1:
		return None
	prefix = parts[0][:-1]
	for part in parts[1:]:
		if not part.startswith(prefix):
			return None
	return prefix

def buildParamTupletAliases(dat: 'DAT', paramTable: 'DAT'):
	dat.clear()
	for i in range(1, paramTable.numRows):
		size = int(paramTable[i, 'size'])
		if size > 1:
			dat.appendRow([
				'#define {} vec{}({})'.format(paramTable[i, 'tuplet'].val, size, ','.join([
					paramTable[i, f'part{j + 1}'].val
					for j in range(size)
				]))
			])

def prepareBufferTable(dat):
	dat.clear()
	table = dat.inputs[0]
	name = parent().par.Name
	dat.appendCol([
		'{}_{}:{}:{}'.format(name, table[i, 0], table[i, 1], table[i, 2] if table.numCols > 2 else 'float')
		for i in range(table.numRows)
	])

def prepareTextureTable(dat):
	dat.clear()
	table = dat.inputs[0]
	name = parent().par.Name
	dat.appendCol([
		'{}_{}:{}'.format(name, table[i, 0], table[i, 1])
		for i in range(table.numRows)
	])

_spaceRx = re.compile('\\s+')
_localMacroEscape = '//-#'

def prepareShaderCode(code: str):
	if not code:
		return ''
	code = _stripLineComments(code)
	currentFuncTypeDat = op('current_funcType')
	code = re.sub(r'\bTHIS_RETURN_TYPE\b', currentFuncTypeDat[1, 'returnType'].val, code)
	code = re.sub(r'\bTHIS_COORD_TYPE\b', currentFuncTypeDat[1, 'coordType'].val, code)
	# inject name
	name = str(parent().par.Name)
	code = code.replace('@', name + '_')
	code = code.replace('THIS', name)
	code = code.replace('thismap', name)
	# code = _spaceRx.sub(' ', code)
	return code

def _stripLineComments(code: str):
	if not code:
		return ''
	if '//' not in code:
		return code
	outLines = []
	for line in code.splitlines():
		if line.startswith(_localMacroEscape) or '//' not in line:
			outLines.append(line)
		else:
			outLines.append(line.split('//', maxsplit=1)[0])
	return '\n'.join(outLines)

def buildDefinition(dat: 'DAT'):
	dat.clear()
	materialAddition = op('materialAddition').text.strip()
	buffers = op('buffers')
	textures = op('textures')
	macroTable = op('macros')
	paramTable = op('params')
	paramTupletTable = op('param_tuplets')
	paramDetailTable = op('param_details')
	host = parent().par.Hostop.eval()
	dat.appendCols([
		['name', parent().par.Name],
		['path', host.path if host else ''],
		['definitionPath', parent().path + '/definition' if host else ''],
		['opType', parent().par.Optype],
		['funcType', parent().par.Functype.eval() if host else ''],
		['inputName1', parent().par.Inputname1],
		['inputName2', parent().par.Inputname2],
		['inputName3', parent().par.Inputname3],
		['inputName4', parent().par.Inputname4],
		['paramTable', paramTable.path if host and _isNonEmpty(paramTable) else ''],
		['paramTupletTable', paramTupletTable.path if host and _isNonEmpty(paramTupletTable) else ''],
		['paramDetailTable', paramDetailTable.path if host and _isNonEmpty(paramDetailTable) else ''],
		['buffers', '$'.join([c.val for c in buffers.col(0)])],
		# Don't directly reference the CHOP itself here to avoid a dependency
		['paramSource', parent().path + '/param_vals' if host else ''],
		['functionPath', parent().path + '/function' if host else ''],
		['materialAddition', materialAddition],
		['materials', f'MAT_{parent().par.Name}' if materialAddition else ''],
		['textures', '$'.join([c.val for c in textures.col(0)])],
		['macroTable', macroTable.path if host and _isNonEmpty(macroTable) else ''],
	])

def _isNonEmpty(dat: 'DAT'):
	return dat.numRows > 0 and dat.numCols > 0

def inspect():
	host = parent().par.Hostop.eval()
	if not host:
		return
	inspector = op.rtk.op('inspector')  # type: Union[COMP, Inspector]
	inspector.AttachTo(host)
