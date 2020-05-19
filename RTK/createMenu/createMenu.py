# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

# def onMouseUp(info):
	# if info['startRow'] > 0:
	# 	opName = info['cellText']
	# 	if len(opName) > 0:  # check if empty cell has been clicked
	# 		opsRoot = op.rtk.path + '/operators'  # op to be copied
	# 		thisOp = opsRoot + '/' + opName  # full path
	#
	# 		currentPane = ui.panes.current
	#
	# 		if str(currentPane.type) == 'PaneType.NETWORKEDITOR':
	# 			currentPath = currentPane.owner
	# 			editorx = currentPane.x
	# 			editory = currentPane.y
	# 			# zoom = currentPane.zoom #unused. would probably be nice. but seems towork without
	# 			newOp = currentPath.copy(op(thisOp))
	# 			newOp.nodeX = editorx
	# 			newOp.nodeY = editory
	# 	op.RTKmenuWindow.closeViewer()

def _getActiveEditor():
	pane = ui.panes.current
	if pane.type == PaneType.NETWORKEDITOR:
		return pane
	for pane in ui.panes:
		if pane.type == PaneType.NETWORKEDITOR:
			return pane

class CreateOpMenu:
	def __init__(self, ownerComp, statePars):
		self.ownerComp = ownerComp
		self.statePars = statePars

	@staticmethod
	def CreateOp(path):
		master = op(path)
		if not master:
			return False
		pane = _getActiveEditor()
		if not pane:
			return False
		newOp = pane.owner.copy(master)
		newOp.nodeX = pane.x
		newOp.nodeY = pane.y
		return True

	def OnMouseDown(self, info: dict):
		rowData = info.get('rowData')
		rowObject = rowData and rowData.get('rowObject')
		path = rowObject and rowObject.get('path')
		if path:
			if self.CreateOp(path):
				self.CloseWindow()

	def OnKey(self, key: str, character: str, state: int):
		if not state:
			return
		if key == 'backspace':
			self.statePars.Filter = self.statePars.Filter.eval()[:-1]
		elif key == 'delete':
			self.statePars.Filter = ''
		elif character and (character.isalnum() or character in '_*'):
			self.statePars.Filter += character

	def ShowWindow(self):
		self.statePars.Filter = ''
		self.ownerComp.op('menuWindow').par.winopen.pulse()

	def CloseWindow(self):
		self.ownerComp.op('menuWindow').par.winclose.pulse()
