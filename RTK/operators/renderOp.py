# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

def updateTextureInputs(firstInput):
	sources = op('texture_sources')
	render = op('glsl_render')
	if not firstInput:
		firstInput = op('depth1')
	if firstInput:
		firstInputConnected = False
		for conn in render.inputConnectors:
			if conn.connections and conn.connections[0].owner == firstInput:
				firstInputConnected = True
			else:
				conn.disconnect()
		if not firstInputConnected:
			firstInput.outputConnectors[0].connect(render)
	for i in range(sources.numRows):
		texSelect = op(f'sel_texture_{i}')
		if not texSelect:
			parent().addError('Too many texture sources')
			return
		texSelect.outputConnectors[0].connect(render)
