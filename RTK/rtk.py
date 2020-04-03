
# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

class _Extension:
	def __init__(self, ownerComp):
		self.ownerComp = ownerComp

class RtkExt(_Extension):
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
