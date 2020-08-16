from typing import Any, Dict, List, Optional, Union
from dataclasses import dataclass, field

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *
	from _stubs.ArcBallExt import ArcBallExt
	ext.Inspector = Inspector()
	ipar = Any()
	ipar.inspectorCore = Any()


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

def _hasRtkTag(o: COMP):
	for tag in o.tags:
		if tag.startswith('rtk'):
			return True
	return False

def _findRtkOp(o: COMP):
	if not o or not o.isCOMP:
		return None
	if _hasRtkTag(o):
		if o.op('definition') or o.op('definition_out'):
			return o
	for child in o.findChildren(tags=['rtkRender']):
		return child
	children = o.findChildren(tags=['rtk*'])
	for child in sorted(children, key=lambda c: c.nodeX, reverse=True):
		if child.op('definition') or child.op('definition_out'):
			return child
	return None

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
		if not hostOp or not hostOp.isCOMP:
			self._HostOp = ''
			self.statePar.Selectedop = ''
			self.DetachRenderer()
			return
		hostOp = _findRtkOp(hostOp)
		if not hostOp:
			return
		self._HostOp = hostOp.path
		self.statePar.Selectedop = ''
		self.AttachRenderer()
		self.OpenWindow()

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

	def OpenWindow(self, par=None):
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

	def ShowInEditor(self, par=None):
		hostOp = self._HostOp
		if not hostOp:
			return
		editor = _getActiveEditor()
		if not editor:
			editor = ui.panes.createFloating(type=PaneType.NETWORKEDITOR)
		editor.owner = hostOp.parent()
		editor.home(op=self.statePar.Selectedop.eval() or hostOp)

	@staticmethod
	def DefinitionOpColumnNames():
		return ['globalName', 'enabled']

	@staticmethod
	def DefinitionOpValues(o: 'COMP', dat: 'DAT', row: int):
		inDat = dat.inputs[0]
		return [
			inDat[row, 'name'] if row < inDat.numRows else '',
			int(o.par.Enable) if hasattr(o.par, 'Enable') else '',
		]

	@property
	def _Definitions(self) -> 'DAT':
		return ipar.inspectorCore.Definitions.eval()

	@property
	def _SelectedDefinition(self) -> 'DAT':
		return ipar.inspectorCore.Selecteddefinition.eval()

	@property
	def _SelectedOp(self) -> 'Optional[COMP]':
		return op(self._SelectedDefinition['path', 1])

	@property
	def FunctionCodeSource(self):
		selOp = self._SelectedOp
		if selOp:
			switcher = selOp.op('functionSwitcher') or selOp.op('axisSwitcher')
			if switcher:
				if len(switcher.inputConnectors) > 1 and len(switcher.inputConnectors[1].connections) > 0:
					func = switcher.inputConnectors[1].connections[0].owner
					if func:
						return func
		sourceDefinition = op(self._SelectedDefinition['definitionPath', 1])
		if not sourceDefinition:
			return ''
		return sourceDefinition.parent().par.Functemplate.eval() or ''

	@property
	def SelectedIsCustomOrNonCloned(self):
		selOp = self._SelectedOp
		if not selOp:
			return False
		if hasattr(selOp.par, 'Functemplate'):
			return True
		master = selOp.par.clone.eval()
		return not master or master == selOp

	@property
	def FunctionCodeSourceForViewer(self):
		selOp = self._SelectedOp
		if not selOp:
			return ''
		if hasattr(selOp.par, 'Functemplate'):
			return selOp.par.Functemplate.eval()
		if self.SelectedIsCustomOrNonCloned:
			return self.FunctionCodeSource
		return self.ownerComp.op('readonly_function_code')

	@property
	def CanSaveFunctionCode(self):
		dat = self.FunctionCodeSourceForViewer
		if dat and getattr(dat.par, 'file', None) and hasattr(dat.par, 'writepulse'):
			return True
		return False

	def SaveFunctionCode(self):
		dat = self.FunctionCodeSourceForViewer
		dat.par.writepulse.pulse()

	def _BuildNodeTree(self) -> 'Optional[_NodeTree]':
		definitions = self._Definitions
		if definitions.numRows < 2:
			return None
		nodesByName = {}  # type: Dict[str, _Node]
		for row in range(1, definitions.numRows):
			name = definitions[row, 'name'].val
			node = _Node(name)
			for col in ['inputName1', 'inputName2', 'inputName3', 'inputName4']:
				inputName = definitions[row, col].val
				if inputName:
					node.inputNames.append(inputName)
			nodesByName[name] = node
		for node in nodesByName.values():
			node.inputs = [
				nodesByName[inputName]
				for inputName in node.inputNames
			]
		root = nodesByName[definitions[1, 'name'].val]
		root.assignDepth(0)
		return _NodeTree(root=root, nodesByName=nodesByName)

	def BuildNodeTreeTable(self, dat: 'DAT'):
		dat.clear()
		dat.appendRow(['name', 'col', 'row', 'inputs'])
		tree = self._BuildNodeTree()
		if not tree:
			return
		nodesByDepth = {}  # type: Dict[int, List[_Node]]
		for node in tree.nodesByName.values():
			if node.depth not in nodesByDepth:
				nodesByDepth[node.depth] = []
			col = len(nodesByDepth[node.depth])
			nodesByDepth[node.depth].append(node)
			dat.appendRow([
				node.name,
				col,
				node.depth,
				' '.join(node.inputNames),
			])

	@staticmethod
	def BuildNodeConnectorsTable(dat: 'DAT', nodeTable: 'DAT'):
		dat.clear()
		dat.appendRow(['fromNode', 'toNode', 'fromCol', 'fromRow', 'toCol', 'toRow'])
		if nodeTable.numRows < 2:
			return
		for nodeName in nodeTable.col('name')[1:]:
			inputNames = nodeTable[nodeName, 'inputs']
			if not inputNames:
				continue
			dat.appendRows([
				[
					inputName, nodeName,
					nodeTable[inputName, 'col'], nodeTable[inputName, 'row'],
					nodeTable[nodeName, 'col'], nodeTable[nodeName, 'row'],
				]
				for inputName in inputNames.val.split(' ')
			])

	@staticmethod
	def BuildConnectorGeos(sop: 'scriptSOP', connectorTable: 'DAT'):
		sop.clear()
		if connectorTable.numRows < 2:
			return
		for i in range(1, connectorTable.numRows):
			x1 = float(connectorTable[i, 'fromCol'])
			x2 = float(connectorTable[i, 'toCol'])
			y1 = float(connectorTable[i, 'fromRow']) - 0.25
			y2 = float(connectorTable[i, 'toRow']) + 0.25
			if x1 == x2:
				line = sop.appendPoly(2, closed=False, addPoints=True)
				line[0].point.x = x1
				line[0].point.y = y1
				line[1].point.x = x2
				line[1].point.y = y2
			else:
				line = sop.appendBezier(4, closed=False, order=4, addPoints=True)
				line[0].point.x = line[1].point.x = x1
				line[2].point.x = line[3].point.x = x2
				line[0].point.y = y1
				line[1].point.y = line[2].point.y = (y2 + y1) / 2.0
				line[3].point.y = y2

	def OnNodeTreePick(self, renderPickChop: 'CHOP'):
		chan = renderPickChop['nodeIndex']
		if chan is None:
			return
		index = int(chan)
		definitions = self._Definitions
		if index < (definitions.numRows - 1):
			path = definitions[index + 1, 'path']
			if path:
				self.statePar.Selectedop = path

	Openwindow = OpenWindow
	Showineditor = ShowInEditor

def _getActiveEditor():
	pane = ui.panes.current
	if pane.type == PaneType.NETWORKEDITOR:
		return pane
	for pane in ui.panes:
		if pane.type == PaneType.NETWORKEDITOR:
			return pane

@dataclass
class _Node:
	name: str
	inputNames: List[str] = field(default_factory=list)
	inputs: List['_Node'] = field(default_factory=list)
	depth: Optional[int] = None

	def assignDepth(self, depth: int):
		self.depth = depth
		for inputNode in self.inputs:
			if inputNode.depth is None:
				inputNode.assignDepth(depth + 1)

@dataclass
class _NodeTree:
	root: _Node
	nodesByName: Dict[str, _Node] = field(default_factory=dict)
