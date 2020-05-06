import re
from typing import Optional, Union

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *
	from _stubs.ArcBallExt import ArcBallExt
	ext.Inspector = Inspector()

def extractShaderPartNames(shaderCode):
	if not shaderCode:
		return []
	return re.findall(r'///----BEGIN (\w+)', shaderCode)

def filterShaderCode(shaderCode, part):
	if not shaderCode:
		return ''
	if not part or part == 'all':
		return shaderCode
	match = re.search(r'///----BEGIN {0}\n(.*)\n///----END {0}'.format(part), shaderCode, re.DOTALL)
	if not match:
		return ''
	return match.group(1)


# the drop function takes the following arguments and according to the dropped type
# calls a function in the /sys attached DragDrop extension
#  
# dropName: dropped node name or filename
# [x/y]Pos: position in network pane
# index: index of dragged item
# totalDragged: total amount of dragged items
# dropExt: operator type or file extension of dragged item
# baseName: dragged node parent network or parent directory of dragged file
# destPath: dropped network

def onDrop(dropName, xPos, yPos, index, totalDragged, dropExt, baseName, destPath):
	# print(parent().path, 'DROP ' + repr(locals()))
	parentOp = op(baseName)
	o = parentOp.op(dropName)
	ext.Inspector.AttachTo(o)

class Inspector:
	def __init__(self, ownerComp):
		self.ownerComp = ownerComp
		self.statePar = ownerComp.op('iparState').par
		self.arcBallCamera = ownerComp.op('cam')  # type: Union[cameraCOMP, ArcBallExt]

	@property
	def _HostOp(self) -> 'Optional[COMP]':
		return self.ownerComp.par.Hostop.eval()

	@_HostOp.setter
	def _HostOp(self, hostOp: 'Optional[COMP]'):
		self.ownerComp.par.Hostop = hostOp or ''

	def AttachTo(self, hostOp: 'Optional[COMP]'):
		if hostOp and (not hostOp.isCOMP or not (hostOp.op('definition') or hostOp.op('definition_out'))):
			return
		self._HostOp = hostOp.path if hostOp else ''
		self.statePar.Selectedop = ''
		if hostOp:
			self.AttachRenderer()
			self.OpenWindow()
		else:
			self.DetachRenderer()

	def Detatch(self):
		self.AttachTo(None)

	def AttachRenderer(self):
		hostOp = self._HostOp
		if hostOp and 'rtkRender' in hostOp.tags:
			renderer = hostOp
			if renderer:
				self.statePar.Renderer = renderer
				cam = renderer.par.Camera.eval()  # type: cameraCOMP
				if cam:
					self.arcBallCamera.LoadTransform(matrix=cam.transform())

	def DetachRenderer(self):
		self.statePar.Renderer = self.ownerComp.op('render')

	def OpenWindow(self, *unused):
		win = self.ownerComp.op('window')
		if not win.isOpen:
			win.par.winopen.pulse()

	# def OnCamMatrixChange(self, dat: 'DAT'):
	# 	if dat.numRows != 4 or dat.numCols != 4:
	# 		return
	# 	renderer = self.statePar.Renderer.eval()
	# 	if not renderer:
	# 		return
	# 	camera = renderer.par.Camera.eval()  # type: cameraCOMP
	# 	if not camera:
	# 		return
	# 	camera.setTransform(self.arcBallCamera.transform())

	Openwindow = OpenWindow
