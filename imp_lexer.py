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

import lexer

RESERVED = 'RESERVED'
ASM_CODE = 'ASM_CODE'
ASM_DATA = 'ASM_DATA'
ASM_INCLUDE = 'ASM_INCLUDE'
INCLUDE = 'INCLUDE'
INT = 'INT'
ID = 'ID'
STRING = 'STRING'

token_exprs = [
    (r'[ \n\t]+', None),
    (r'#[^\n]*', None),

    (r'\(', RESERVED),
    (r'\)', RESERVED),
    (r';', RESERVED),
    (r'\[', RESERVED),
    (r'\]', RESERVED),
    (r'\+', RESERVED),
    (r'-', RESERVED),
    (r'\*', RESERVED),
    (r'//', RESERVED),
    (r'/', RESERVED),

    (r'<=', RESERVED),
    (r'<', RESERVED),
    (r'>=', RESERVED),
    (r'>', RESERVED),
    (r'!=', RESERVED),
    (r'==', RESERVED),
    (r'\=', RESERVED),
    (r'иначе', RESERVED),
    (r'или', RESERVED),
    (r'и', RESERVED),
    (r'не', RESERVED),
    (r'если', RESERVED),
    (r'{', RESERVED),
    (r'пока', RESERVED),
    ('вывод', RESERVED),
    ('ввод', RESERVED),
    ('массив', RESERVED),
    (r'включение_ассемблер_data [0-9a-zA-ZА-Яа-я_\.\\/]*', ASM_DATA),
    (r'включение_ассемблер_code [0-9a-zA-ZА-Яа-я_\.\\/]*', ASM_CODE),
    (r'включение [0-9a-zA-ZА-Яа-я_\.\\/]*', INCLUDE),
    (r'ассемблер_include [0-9a-zA-ZА-Яа-я_\.\\/]*', ASM_INCLUDE),
    (r'{', RESERVED),
    (r'}', RESERVED),
    (r'[0-9]+', INT),
    (r'[A-Za-zА-Яа-я][A-Za-zА-Яа-я0-9_]*', ID),
    (r'"(.*?)"', STRING),
    (r'.', RESERVED)
]
KEYWORDS_TOKENS = {"иначе", "или", "и", "не", "если", "пока", "вывод", "ввод", "массив"}


def imp_lex(characters):
    return lexer.lex(characters, token_exprs)


token_exprs228 = [

    (r'[ \n\t]+', None),
    (r'#[^\n]*', None),
(r'[A-Za-zА-Яа-я][A-Za-zА-Яа-я0-9_]*', ID),
    (r'\(', RESERVED),
    (r'\)', RESERVED),
    (r';', RESERVED),
    (r'\[', RESERVED),
    (r'\]', RESERVED),
    (r'\+', RESERVED),
    (r'-', RESERVED),
    (r'\*', RESERVED),
    (r'//', RESERVED),
    (r'/', RESERVED),

    (r'<=', RESERVED),
    (r'<', RESERVED),
    (r'>=', RESERVED),
    (r'>', RESERVED),
    (r'!=', RESERVED),
    (r'==', RESERVED),
    (r'\=', RESERVED),
    (r'иначе', RESERVED),
    (r'или', RESERVED),
    (r'и', RESERVED),
    (r'не', RESERVED),
    (r'если', RESERVED),
    (r'{', RESERVED),
    (r'пока', RESERVED),
    ('вывод', RESERVED),
    ('ввод', RESERVED),
    ('массив', RESERVED),
    (r'включение_ассемблер_data [0-9a-zA-ZА-Яа-я_\.\\/]*', ASM_DATA),
    (r'включение_ассемблер_code [0-9a-zA-ZА-Яа-я_\.\\/]*', ASM_CODE),
    (r'включение [0-9a-zA-ZА-Яа-я_\.\\/]*', INCLUDE),
    (r'ассемблер_include [0-9a-zA-ZА-Яа-я_\.\\/]*', ASM_INCLUDE),
    (r'{', RESERVED),
    (r'}', RESERVED),
    (r'[0-9]+', INT),
    (r'"(.*?)"', STRING),
    (r'.', RESERVED)
]