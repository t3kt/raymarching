import re
from typing import List, Tuple

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

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

def buildShaderExports(dat):
	dat.clear()
	dat.appendRow(['path', 'parameter', 'value'])
	i = 0
	# don't directly reference the chop using `op()` since that may introduce
	# a dependency causing extra cooks
	_addArray(
		dat, i, 'vecParams',
		parent().path + '/merged_vector_param_vals',
		'vec4', 'uniformarray')
	i += 1
	if parent().par.Supportlights:
		_addArray(
			dat, i, 'lights',
			parent().par.Lightschop.eval().path if parent().par.Lightschop else '',
			'vec3', 'uniformarray')
		i += 1
		_addArray(
			dat, i, 'lightColors',
			parent().par.Lightcolorschop.eval().path if parent().par.Lightcolorschop else '',
			'vec4', 'uniformarray')
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

def buildParamAliaseMacros(dat: 'DAT', paramDetails: 'DAT'):
	dat.clear()
	for name, expr in _getParamAliases(paramDetails):
		dat.appendRow([f'#define {name} {expr}'])

def buildParamAliasTable(dat: 'DAT', paramDetails: 'DAT'):
	dat.clear()
	dat.appendRow(['before', 'after'])
	for name, expr in _getParamAliases(paramDetails):
		dat.appendRow([name, expr])

def _getParamAliases(paramDetails: 'DAT') -> List[Tuple[str, str]]:
	suffixes = 'xyzw'
	results = []
	for i in range(paramDetails.numRows - 1):
		tupletName = paramDetails[i + 1, 'tuplet']
		size = int(paramDetails[i + 1, 'size'])
		if size == 1:
			name = paramDetails[i + 1, 'part1']
			results.append((str(name), f'vecParams[{i}].x'))
		else:
			if size == 4:
				results.append((str(tupletName), f'vecParams[{i}]'))
			else:
				results.append((str(tupletName), f'vec{size}(vecParams[{i}].{suffixes[:size]})'))
			for partI in range(1, 5):
				name = paramDetails[i + 1, f'part{partI}']
				if name:
					suffix = suffixes[partI - 1]
					results.append((str(name), f'vecParams[{i}].{suffix}'))
	return results

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

