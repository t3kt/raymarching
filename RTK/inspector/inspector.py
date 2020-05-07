import re
from typing import Dict, List, Optional, Union
from dataclasses import dataclass, field

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

	def _BuildNodeTree(self) -> 'Optional[_NodeTree]':
		definitions = self.ownerComp.op('definitions')
		if definitions.numRows < 2:
			return None
		nodesByName = {}  # type: Dict[str, _Node]
		for row in range(1, definitions.numRows):
			name = definitions[row, 'name'].val
			node = _Node(name)
			for col in ['inputName1', 'inputName2']:
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

	def BuildNodeTreeIndentedTable(self, dat: 'DAT'):
		dat.clear()
		tree = self._BuildNodeTree()
		if not tree:
			return
		coveredNames = set()

		def _addNode(node: _Node):
			dat.appendRow(([''] * node.depth) + [node.name])
			if node.name not in coveredNames:
				coveredNames.add(node.name)
				for inputNode in node.inputs:
					_addNode(inputNode)

		_addNode(tree.root)

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
			inputNames = nodeTable[nodeName, 'inputs'].val
			if not inputNames:
				continue
			dat.appendRows([
				[
					inputName, nodeName,
					nodeTable[inputName, 'col'], nodeTable[inputName, 'row'],
					nodeTable[nodeName, 'col'], nodeTable[nodeName, 'row'],
				]
				for inputName in inputNames.split(' ')
			])

	@staticmethod
	def BuildConnectorGeos(sop: 'scriptSOP', connectorTable: 'DAT'):
		sop.clear()
		if connectorTable.numRows < 2:
			return
		for i in range(1, connectorTable.numRows):
			line = sop.appendPoly(2, closed=False, addPoints=True)
			line[0].point.x = float(connectorTable[i, 'fromCol'])
			line[0].point.y = float(connectorTable[i, 'fromRow']) - 0.25
			line[1].point.x = float(connectorTable[i, 'toCol'])
			line[1].point.y = float(connectorTable[i, 'toRow']) + 0.25

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
