# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def buildBufferTable(dat: 'DAT', bufferSpecs: 'DAT'):
	dat.clear()
	dat.appendRow(['name', 'chop', 'type'])
	raise NotImplementedError()

def buildTextureTable(dat: 'DAT', specs: 'DAT'):
	dat.clear()
	dat.appendRow(['name', 'top', 'aliases'])
	if not specs.numRows or not specs.numCols:
		return
	namesByPath = {}
	for cell in specs.col(0):
		if not cell.val:
			continue
		specs = cell.val.split(' ')
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
