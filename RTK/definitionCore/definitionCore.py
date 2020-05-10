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
	dat.appendCol([name + '_' + pn for pn in allParamNames])

def buildParamTupletTable(dat: 'DAT'):
	dat.clear()
	params = _getRegularParams()
	if not params:
		return
	paramsByTuplet = {}  # type: Dict[str, List[Par]]
	for par in params:
		if len(par.tuplet) == 1:
			continue
		if par.tupletName in paramsByTuplet:
			paramsByTuplet[par.tupletName].append(par)
		else:
			paramsByTuplet[par.tupletName] = [par]
	name = parent().par.Name.eval()
	for tupletName, tupletPars in paramsByTuplet.items():
		tupletPars = list(sorted(tupletPars, key=lambda p: p.vecIndex))
		dat.appendRow([
			'#define {}_{} vec{}({})'.format(
				name, tupletName, len(tupletPars),
				','.join([name + '_' + p.name for p in tupletPars]))
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

_lineCommentRx = re.compile('//.*\n')
_spaceRx = re.compile('\\s+')

def prepareShaderCode(code: str):
	if not code:
		return ''
	# strip line comments
	code = _lineCommentRx.sub(' ', code)
	# inject name
	name = str(parent().par.Name)
	code = code.replace('@', name + '_')
	code = code.replace('THIS', name)
	code = _spaceRx.sub(' ', code)
	return code

def buildDefinition(dat: 'DAT'):
	dat.clear()
	materialAddition = op('materialAddition').text.strip()
	buffers = op('buffers')
	textures = op('textures')
	macroTable = op('macros')
	paramTable = op('params')
	paramTupletTable = op('param_tuplets')
	host = parent().par.Hostop.eval()
	dat.appendCols([
		['name', parent().par.Name],
		['path', host.path if host else ''],
		['definitionPath', parent().path + '/definition' if host else ''],
		['opType', parent().par.Optype],
		['inputName1', parent().par.Inputname1],
		['inputName2', parent().par.Inputname2],
		['paramTable', paramTable.path if host and _isNonEmpty(paramTable) else ''],
		['paramTupletTable', paramTupletTable.path if host and _isNonEmpty(paramTupletTable) else ''],
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
