import re

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

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

def prepareMacroTable(dat):
	dat.clear()
	table = dat.inputs[0]
	if not table.numRows:
		return
	name = parent().par.Name
	dat.appendRows([
		[
			table[i, 0].val.replace('@', name + '_'),
			table[i, 1] if table.numCols > 1 else '',
		]
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
	# encode line ends
	code = code.replace('\n', '\\n')
	code = _spaceRx.sub(' ', code)
	return code

def buildDefinition(dat: 'DAT'):
	dat.clear()
	materialAddition = op('materialAddition').text.strip()
	buffers = op('buffers')
	textures = op('textures')
	macroTable = op('macros')
	if macroTable.numRows > 0:
		macros = '$'.join([
			f'{name}:{val}' if val != '' else f'{name}'
			for name, val in macroTable.rows()
		])
	else:
		macros = ''
	host = parent().par.Hostop.eval()
	dat.appendCols([
		['name', parent().par.Name],
		['path', host.path if host else ''],
		['definitionPath', parent().path + '/definition' if host else ''],
		['opType', parent().par.Optype],
		['inputName1', parent().par.Inputname1],
		['inputName2', parent().par.Inputname2],
		['paramTable', op('params').path if host else ''],
		['buffers', '$'.join([c.val for c in buffers.col(0)])],
		# Don't directly reference the CHOP itself here to avoid a dependency
		['paramSource', parent().path + '/param_vals' if host else ''],
		['function', op('function').text],
		['materialAddition', materialAddition],
		['materials', f'MAT_{parent().par.Name}' if materialAddition else ''],
		['textures', '$'.join([c.val for c in textures.col(0)])],
		['macros', macros],
		['macrosPath', parent().path + '/macros' if host else ''],
	])

def inspect():
	host = parent().par.Hostop.eval()
	if not host:
		return
	inspector = op.rtk.op('inspector')
	inspector.par.Hostop = host
	inspector.par.Openwindow.pulse()
