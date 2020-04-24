import re

# noinspection PyUnreachableCode
if False:
	# noinspection PyUnresolvedReferences
	from _stubs import *

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
	print(parent().path, 'DROP ' + repr(locals()))
	parentOp = op(baseName)
	o = parentOp.op(dropName)
	if o.isCOMP:
		o = o.op('definition') or o.op('definition_out')
	if o and o.isDAT:
		parent().par.Definition = o
