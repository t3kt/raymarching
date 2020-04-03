
# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

class RtkExt:
	def __init__(self, ownerComp):
		self.ownerComp = ownerComp

	def ReloadTextures(self):
		textureTable = self.ownerComp.op('textureTable')
		textureTable.clear()
		texturesComp = self.ownerComp.par.Texturescomp.eval()
		if not texturesComp:
			return
		children = texturesComp.children
		j = 0
		for child in children:
			if 'texture' in child.name.lower():
				textureTable.appendRow([j, child])
				j += 1

def _BuildDefinesFromTable(outDat: 'textDAT', table: 'DAT'):
	outDat.clear()
	outDat.text = '\n'.join([
		f'#define {table[i, 0]} {table[i, 1]}'
		for i in range(table.numRows)
	])
