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

	def CreateOp(self, path):
		master = op(path)
		if not master:
			return
		pane = _getActiveEditor()
		if not pane:
			return
		newOp = pane.owner.copy(master)
		newOp.nodeX = pane.x
		newOp.nodeY = pane.y

	def OnMouseDown(self, info: dict):
		rowData = info.get('rowData')
		rowObject = rowData and rowData.get('rowObject')
		path = rowObject and rowObject.get('path')
		if path:
			self.CreateOp(path)
