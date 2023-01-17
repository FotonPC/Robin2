#!/usr/bin/env python

# Copyright (c) 2011, Jay Conrod.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Jay Conrod nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL JAY CONROD BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import sys
import parse
from imp_lexer import *
import ro_asm_compiler

IF = ''
ELSE = ''
WHILE = ''
AND = ''
OR = ''
NOT = ''

BLOCK_END = '}'
BLOCK_BEGIN = '{'
SEPARATOR = ';'


class LowLevelStatement:

    def __init__(self, tokens):
        pass


class Statement:  # дерево по ; и {}

    def __init__(self, tokens):

        self.statements = []

        is_low_level_statement = True

        for token in tokens:
            if token[0] == SEPARATOR:
                is_low_level_statement = False

        if is_low_level_statement:
            self.statements.append([LowLevelStatement(tokens)])
            return

        nesting_lvl = 0

        index = 0

        part_begin = 0

        while index < len(tokens):
            if nesting_lvl == 0:
                if tokens[index][0] == SEPARATOR:
                    self.statements.append(Statement(tokens[part_begin:index]))
                    part_begin = index + 1
                    index += 1
                    continue
            if tokens[index][1] == RESERVED:
                if tokens[index][0] == BLOCK_BEGIN:
                    nesting_lvl += 1
                elif tokens[index][0] == BLOCK_END:
                    nesting_lvl -= 1
            index += 1



def usage():
    sys.stderr.write('Usage: imp filename\n')
    sys.exit(1)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        usage()
    filename = sys.argv[1]
    text = open(filename, encoding='utf-8').read()

    print(text)

    tokens = imp_lex(text)
    print(tokens)
    parse_result = parse.Statement(tokens=tokens)
    print(parse_result.build_tree())
    print(parse_result.get_vars())
    print(parse_result.get_numbers())
    with open('hello.roasm', 'w+') as f:
        f.write(ro_asm_compiler.make_asm(parse_result))

    if not parse_result:
        sys.stderr.write('Parse error!\n')
        sys.exit(1)

    sys.stdout.write('Final variable values:\n')
