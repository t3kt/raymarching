from dataclasses import dataclass
from typing import Callable, List

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

@dataclass
class _ToolContext:
	toolName: str
	component: 'COMP'
	editorPane: 'NetworkEditor'

@dataclass
class _ToolDefinition:
	name: str
	action: Callable[[_ToolContext], None]
	label: str = None
	icon: str = None

class _Tools:
	def __init__(self, context: _ToolContext):
		self.context = context
		self.comp = context.component

	def _findRtkRenderer(self):
		for child in self.comp.findChildren(type=baseCOMP, tags=['rtkRender']):
			return child

	def _findCamera(self):
		renderer = self._findRtkRenderer()
		if renderer:
			cam = renderer.par.Camera.eval()
			if cam:
				return cam
		for cam in self.comp.ops('cam', 'cam1'):
			return cam
		for cam in self.comp.findChildren(type=cameraCOMP):
			return cam

	def _getParamFilterOutput(self):
		parFilter = self.comp.op('param_filter') or self.comp.op('paramFilter')
		if not parFilter:
			return None
		for o in parFilter.outputs:
			if o.isCHOP:
				return o

	def addCameraControls(self):
		cam = self._findCamera()
		if not cam:
			raise Exception('Camera not found!')
		valsChop = self._getParamFilterOutput()
		if not self.comp.customPages:
			page = self.comp.appendCustomPage('Generator')
		else:
			page = self.comp.customPages[0]
		for suffix in 'xyz':
			name = 'Camtranslate' + suffix
			if hasattr(self.comp.par, name):
				continue
			par = page.appendFloat(name, label='Cam Translate ' + suffix.upper())[0]
			par.normMin = -4
			par.normMax = 4
			innerPar = getattr(cam.par, 't' + suffix)  # type: Par
			par.default = innerPar.eval()
			if valsChop:
				innerPar.expr = f'op("{valsChop.name}")["{name}"]'
			else:
				innerPar.expr = f'parent().par.{name}'
		for suffix in 'xyz':
			name = 'Camrotate' + suffix
			if hasattr(self.comp.par, name):
				continue
			par = page.appendFloat(name, label='Cam Rotate ' + suffix.upper())[0]
			par.normMin = -180
			par.normMax = 180
			innerPar = getattr(cam.par, 'r' + suffix)  # type: Par
			par.default = innerPar.eval()
			if valsChop:
				innerPar.expr = f'op("{valsChop.name}")["{name}"]'
			else:
				innerPar.expr = f'parent().par.{name}'

def _createTool(method: Callable, label: str = None, icon: str = None):
	def _action(context: _ToolContext):
		tools = _Tools(context)
		method(tools)
	return _ToolDefinition(method.__name__, _action, label=label, icon=icon)

def getEditorTools() -> List[_ToolDefinition]:
	tools = [
		_createTool(_Tools.addCameraControls, 'Add Camera Controls')
	]
	return tools
