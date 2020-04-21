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

_lineCommentRx = re.compile('//.*\n')
_spaceRx = re.compile('\\s+')

class Definition:
	def __init__(self, ownerComp: 'COMP'):
		self.ownerComp = ownerComp
		self.hostOp = ownerComp.par.Hostop.eval()  # type: COMP

	@property
	def _Name(self): return self.ownerComp.par.Name.eval()

	def PrepareShaderCode(self, code: str):
		if not code:
			return ''
		# strip line comments
		code = _lineCommentRx.sub(' ', code)
		# inject name
		code = code.replace('@', self._Name + '_')
		# encode line ends
		code = code.replace('\n', '\\n')
		code = _spaceRx.sub(' ', code)
		return code
