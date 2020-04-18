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
