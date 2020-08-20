#!/usr/bin/env python

# based on https://github.com/interpreters/pypreprocessor
# with modifications by t3kt

# ORIGINAL __author__ = 'Evan Plaice'
# ORIGINAL __coauthor__ = 'Hendi O L, Epikem'
# ORIGINAL __version__ = '0.7.7'

from typing import Tuple

class PreprocessorException(Exception):
	pass

class Preprocessor:
	def __init__(
			self,
			defines=None,
			removeMeta=False,
			escape='#',
	):
		# public variables
		self.defines = defines
		self.removeMeta = removeMeta
		self.escape = escape
		# private variables
		self.__linenum = 0
		self.__excludeblock = False
		self.__ifblocks = []
		self.__ifconditions = []
		self.__evalsquelch = True
		self.__outputBuffer = ''
		self.__warnings = []

	# reseting internal things to parse again
	def __reset_internal(self):
		self.__linenum = 0
		self.__excludeblock = False
		self.__ifblocks = []
		self.__ifconditions = []
		self.__evalsquelch = True
		self.__outputBuffer = ''
		self.__warnings = []

	# the #define directive
	def define(self, define):
		self.defines.append(define)

	# the #undef directive
	def undefine(self, define):
		# re-map the defines list excluding the define specified in the args
		self.defines[:] = [x for x in self.defines if x != define]

	# search: if define is defined
	def search_defines(self, define):
		return define in self.defines

	# returning: validness of #ifdef #else block
	def __if(self):
		value = bool(self.__ifblocks)
		for ib in self.__ifblocks:
			value *= ib  # * represents and: value = value and ib
		return not value  # not: because True means removing

	# evaluate
	def lexer(self, line) -> Tuple[bool, bool]:
		# return values are (squelch, metadata)
		if not (self.__ifblocks or self.__excludeblock):
			if 'pypreprocessor.parse()' in line:
				return True, True
			# this block only for faster processing (not necessary)
			elif line[:len(self.escape)] != self.escape:
				return False, False
		# handle #define directives
		if line[:len(self.escape) + 6] == self.escape + 'define':
			parts = line.split()
			if len(parts) < 2:
				self.exit_error(self.escape + 'define')
			if len(line.split()) != 2:
				#self.exit_error(self.escape + 'define')
				return False, False
			else:
				self.define(line.split()[1])
				return False, True
		# handle #undef directives
		elif line[:len(self.escape) + 5] == self.escape + 'undef':
			if len(line.split()) != 2:
				self.exit_error(self.escape + 'undef')
			else:
				self.undefine(line.split()[1])
				return False, True
		# handle #exclude directives
		elif line[:len(self.escape) + 7] == self.escape + 'exclude':
			if len(line.split()) != 1:
				self.exit_error(self.escape + 'exclude')
			else:
				self.__excludeblock = True
				return False, True
		# handle #endexclude directives
		elif line[:len(self.escape) + 10] == self.escape + 'endexclude':
			if len(line.split()) != 1:
				self.exit_error(self.escape + 'endexclude')
			else:
				self.__excludeblock = False
				return False, True
		# handle #ifnotdef directives (is the same as: #ifdef X #else)
		elif line[:len(self.escape) + 8] == self.escape + 'ifdefnot':
			if len(line.split()) != 2:
				self.exit_error(self.escape + 'ifdefnot')
			else:
				self.__ifblocks.append(not self.search_defines(line.split()[1]))
				self.__ifconditions.append(line.split()[1])
				return False, True
		# handle #ifdef directives
		elif line[:len(self.escape) + 5] == self.escape + 'ifdef':
			if len(line.split()) != 2:
				self.exit_error(self.escape + 'ifdef')
			else:
				self.__ifblocks.append(self.search_defines(line.split()[1]))
				self.__ifconditions.append(line.split()[1])
				return False, True
		# handle #else...
		# handle #elseif directives
		elif line[:len(self.escape) + 6] == self.escape + 'elseif':
			if len(line.split()) != 2:
				self.exit_error(self.escape + 'elseif')
			else:
				self.__ifblocks[-1] = not self.__ifblocks[-1]
				# self.search_defines(self.__ifconditions[-1]))
				self.__ifblocks.append(self.search_defines(line.split()[1]))
				self.__ifconditions.append(line.split()[1])
			return False, True
		# handle #else directives
		elif line[:len(self.escape) + 4] == self.escape + 'else':
			if len(line.split()) != 1:
				self.exit_error(self.escape + 'else')
			else:
				self.__ifblocks[-1] = not self.__ifblocks[-1]
			# self.search_defines(self.__ifconditions[-1]))
			return False, True
		# handle #endif..
		# handle #endififdef
		elif line[:len(self.escape) + 10] == self.escape + 'endififdef':
			if len(line.split()) != 2:
				self.exit_error(self.escape + 'endififdef')
			else:
				if len(self.__ifconditions) >= 1:
					self.__ifblocks.pop(-1)
					self.__ifcondition = self.__ifconditions.pop(-1)
				else:
					self.__ifblocks = []
					self.__ifconditions = []
				self.__ifblocks.append(self.search_defines(line.split()[1]))
				self.__ifconditions.append(line.split()[1])
				return False, True
		# handle #endifall directives
		elif line[:len(self.escape) + 8] == self.escape + 'endifall':
			if len(line.split()) != 1:
				self.exit_error(self.escape + 'endifall')
			else:
				self.__ifblocks = []
				self.__ifconditions = []
				return False, True
		# handle #endif and #endif numb directives
		elif line[:len(self.escape) + 5] == self.escape + 'endif':
			if len(line.split()) != 1:
				self.exit_error(self.escape + 'endif number')
			else:
				try:
					number = int(line[6:])
				except ValueError as VE:
					# print('ValueError',VE)
					# self.exit_error(self.escape + 'endif number')
					number = 1
				if len(self.__ifconditions) > number:
					for i in range(0, number):
						self.__ifblocks.pop(-1)
						self.__ifcondition = self.__ifconditions.pop(-1)
				elif len(self.__ifconditions) == number:
					self.__ifblocks = []
					self.__ifconditions = []
				else:
					self._addWarning('Warning try to remove more blocks than present', includeLine=True)
					self.__ifblocks = []
					self.__ifconditions = []
				return False, True
		else:  # No directive --> execute
			# process the excludeblock
			if self.__excludeblock is True:
				return True, False
			# process the ifblock
			elif self.__ifblocks:  # is True:
				return self.__if(), False
			# here can add other stuff for deleting comnments eg
			else:
				return False, False

	# error handling
	def exit_error(self, directive):
		raise PreprocessorException(
			f'Line {self.__linenum}: SyntaxError: Invalid {directive} directive')

	def _addWarning(self, warning: str, includeLine=False):
		if includeLine:
			warning = f'Line {self.__linenum}: {warning}'
		self.__warnings.append(warning)

	# parsing/processing
	def parse(self, inputCode: str) -> str:
		if not inputCode:
			return ''
		self.__reset_internal()
		try:
			# process the input file
			for line in inputCode.splitlines():
				self.__linenum += 1
				# to squelch or not to squelch
				squelch, metaData = self.lexer(line)
				# process and output
				if self.removeMeta is True:
					if metaData is True or squelch is True:
						continue
				if squelch is True:
					if metaData:
						self.__outputBuffer += self.escape + line
					else:
						self.__outputBuffer += self.escape[0] + line
					continue
				if squelch is False:
					self.__outputBuffer += line
					continue
		finally:
			# Warnings for unclosed #ifdef blocks
			if self.__ifblocks:
				self._addWarning(
					f'Warning: Number of unclosed Ifdefblocks: {len(self.__ifblocks)}. '
					'Can cause unwished behaviour in the preprocessed code, preprocessor is safe')
		return self.__outputBuffer

	def getWarnings(self):
		return list(self.__warnings)

