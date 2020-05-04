import re

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def buildParamTable(dat: 'DAT', definitions: 'DAT'):
	dat.clear()
	names = []
	cells = definitions.col('paramTable')
	if not cells:
		return
	for cell in cells[1:]:
		if not cell.val:
			continue
		table = op(cell)
		if not table or not table.numRows:
			continue
		names += [n for n in table.cells('*', '*') if n.val]
	dat.appendCol(names)

def buildBufferTable(dat: 'DAT', specTable: 'DAT'):
	dat.clear()
	dat.appendRow(['name', 'chop', 'type'])
	if not specTable.numRows or not specTable.numCols:
		return
	for cell in specTable.col(0):
		if not cell.val:
			continue
		specs = cell.val.split('$')
		for spec in specs:
			if not spec:
				continue
			parts = spec.split(':')
			dat.appendRow([
				parts[0],
				parts[1],
				parts[2] if len(parts) > 2 else 'float',
			])

def buildTextureTable(dat: 'DAT', specTable: 'DAT'):
	dat.clear()
	dat.appendRow(['name', 'top', 'aliases'])
	if not specTable.numRows or not specTable.numCols:
		return
	namesByPath = {}
	for cell in specTable.col(0):
		if not cell.val:
			continue
		specs = cell.val.split('$')
		for spec in specs:
			if spec:
				parts = spec.split(':')
				name, path = parts[0], parts[1]
				if path not in namesByPath:
					namesByPath[path] = [name]
				elif name not in namesByPath[path]:
					namesByPath[path].append(name)
	for path, names in namesByPath.items():
		dat.appendRow([
			names[0],
			path,
			' '.join(names[1:])
		])

def buildMacroTable(dat: 'DAT', specTable: 'DAT'):
	dat.clear()
	if not specTable.numRows:
		return
	for cell in specTable.col(0):
		if not cell.val:
			continue
		specs = cell.val.split('$')
		for spec in specs:
			if not spec:
				continue
			if ':' in spec:
				name, value = spec.split(':', 1)
			else:
				name, value = spec, ''
			dat.appendRow(['#define', name, value])

def buildShaderExports(dat):
	dat.clear()
	dat.appendRow(['path', 'parameter', 'value'])
	i = 0
	# don't directly reference the chop using `op()` since that may introduce
	# a dependency causing extra cooks
	_addArray(
		dat, i, 'params',
		parent().path + '/merged_param_vals',
		'float', 'uniformarray')
	i += 1
	_addArray(
		dat, i, 'lights',
		parent().par.Lightschop.eval().path if parent().par.Lightschop else '',
		'vec3', 'uniformarray')
	i += 1
	buffTbl = op('buffer_table')
	for row in range(1, buffTbl.numRows):
		_addArray(
			dat, i,
			buffTbl[row, 'name'].val,
			buffTbl[row, 'chop'].val,
			buffTbl[row, 'type'].val,
			'texturebuffer')
		i += 1

def _addArray(dat, i, name, chop, unitType, mode):
	dat.appendRow(['@', f'chopuniname{i}', repr(name)])
	dat.appendRow(['@', f'chopunitype{i}', unitType])
	dat.appendRow(['@', f'chop{i}', repr(chop)])
	dat.appendRow(['@', f'choparraytype{i}', mode])

def buildTextureDefs(dat: 'DAT', textureTable: 'DAT'):
	dat.clear()
	offset = int(parent().par.Textureindexoffset)
	for i in range(1, textureTable.numRows):
		names = [textureTable[i, 'name'].val]
		aliases = textureTable[i, 'aliases'].val
		if aliases:
			names += aliases.split(' ')
		for name in names:
			dat.appendRow([
				f'#define {name} sTD2DInputs[{offset + i - 1}]'
			])

def stripComments(code):
	if not code:
		return ''
	code = re.sub(r'//.*?$', '', code, flags=re.MULTILINE)
	return code

def prepareCode(code):
	if not code:
		return ''
	code = code.replace('\\n', '\n')
	code = code.replace('\n \n', '\n')
	code = re.sub(r'\n\n+', r'\n', code)
	return code

