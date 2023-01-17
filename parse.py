from imp_lexer import RESERVED
import imp_lexer

IF = 'если'
ELSE = 'иначе'
WHILE = 'пока'
ARRAY = 'массив'
AND = 'и'
OR = 'или'
NOT = 'не'
EQUALS = '=='
GOE = '>='
LOE = '<='
GREATER = '>'
LESS = '<'
NOT_EQUALS = '!='
MUL = '*'
DIV = '/'
TRUE_DIV = '//'
FLOAT_POINT = '.'
ADD = '+'
MINUS = '-'

BLOCK_KEYWORDS = [IF, ELSE, WHILE]
OPERATORS = {'+': 'add', '*': 'mul', '-': 'sub', '/': 'div', '==': 'eql', 'и': 'and', 'или': 'or', }

BLOCK_END = '}'
BLOCK_BEGIN = '{'
SEPARATOR = ';'
ASSIGN = '='
PRINT = 'вывод'
INPUT = 'ввод'


class AssignStatement:
    def __init__(self, tokens):
        self.name = tokens[0][0]
        self.condition = ConditionStatement(tokens[2:])
        self.GA = None

    def build_tree(self):
        return 'AssignStatement(' + self.name + ' = ' + self.condition.build_tree() + ')'

    def get_vars(self):
        return [self.name] + self.condition.get_vars()

    def get_numbers(self):
        return self.condition.get_numbers()

    def send_GA(self, GA):
        self.condition.send_GA(GA)
        self.GA = GA

    def assemble(self):
        b, n, ra = self.condition.assemble_final('EAX')
        n = n + '\n' * min(1, len(n)) + f'mov DWORD PTR {self.GA.variable_address(self.name)}, {ra}'
        return b, n


class PrintStatement:
    def __init__(self, tokens):
        self.condition = ConditionStatement(tokens[1:])
        self.GA = None

    def build_tree(self):
        return 'PrintStatement(' + self.condition.build_tree() + ')'

    def get_vars(self):
        return self.condition.get_vars()

    def get_numbers(self):
        return self.condition.get_numbers()

    def send_GA(self, GA):
        self.condition.send_GA(GA)
        self.GA = GA

    def assemble(self):
        begin, now, res_address = self.condition.assemble()
        if str(res_address)[0] != '"':
            now = now + '\n' * min(len(now), 1) + f'outint {res_address}\nnewline'
        else:
            now = now + '\n' * min(len(now), 1) + f'outstr {res_address}\nnewline'
        return begin, now


class InputStatement:
    def __init__(self, tokens):
        if len(tokens) != 2:
            raise RuntimeWarning(tokens, 'слишком много')
        self.name = tokens[1][0]

    def build_tree(self):
        return 'InputStatement(' + self.name + ')'

    def get_vars(self):
        return [self.name]

    def get_numbers(self):
        return []

    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        begin = ''
        now = f'inint ECX ; Компилятор: сохраняем значение в регистр. Кто не понял, тот бот. Это MASM Дитя\n' + \
              f'mov DWORD PTR {self.GA.variable_address(self.name)}, ECX ; Выгружаем значение из регистра куда надо'
        return begin, now


class PassStatement:
    def __init__(self, tokens):
        pass

    def build_tree(self):
        return ''

    def get_vars(self):
        return []

    def get_numbers(self):
        return []

    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        return '', ''


class ASMCodeInclude:
    def __init__(self, tokens):
        self.tokens = tokens
        self.filename = tokens[0][0][25:]
        self.asm_code = open(self.filename).read()

    def build_tree(self):
        return ''

    def get_vars(self):
        return []

    def get_numbers(self):
        return []

    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        now = f'and al, al; Это включение в код, filename - {self.filename}\n{self.asm_code}'
        return '', now


class ASMDataInclude:
    def __init__(self, tokens):
        self.tokens = tokens
        self.filename = tokens[0][0][25:]
        self.asm_data = open(self.filename).read()

    def build_tree(self):
        return ''

    def get_vars(self):
        return []

    def get_numbers(self):
        return []

    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        return self.asm_data, ''


class ASMIncludeAppend:
    def __init__(self, tokens):
        self.tokens = tokens
        self.filename = tokens[0][0][18:]

    def build_tree(self):
        return ''

    def get_vars(self):
        return []

    def get_numbers(self):
        return []

    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        self.GA.append_include(self.filename)
        return '', ''


def LowLevelStatement(tokens):
    if len(tokens) == 0:
        return PassStatement(tokens)
    if 'ASM_CODE' == tokens[0][1]:
        return ASMCodeInclude(tokens)
    if 'ASM_DATA' == tokens[0][1]:
        return ASMDataInclude(tokens)
    if 'ASM_INCLUDE' == tokens[0][1]:
        raise RuntimeWarning(tokens, 'ASSEMBLER_APPEND_INCLUDE')
    if 'INCLUDE' == tokens[0][1]:
        return IncludeCode(tokens)
    if (PRINT, RESERVED) == tokens[0]:
        return PrintStatement(tokens)
    if (INPUT, RESERVED) == tokens[0]:
        return InputStatement(tokens)
    if (ASSIGN, RESERVED) == tokens[1]:
        return AssignStatement(tokens)
    # if (ARRAY, RESERVED) == tokens[0]:
    #    return ArrayStatement(tokens)

    raise RuntimeWarning(tokens, 'что то не то')


class NumberStatement:
    def __init__(self, tokens):
        self.value = int(tokens[0][0])

    def build_tree(self):
        return str(self.value)

    def get_vars(self):
        return []

    def get_numbers(self):
        return [self.value]

    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        begin = ''
        now = ''
        res_address = self.value
        return begin, now, res_address

    def assemble_final(self, res_address):
        begin = ''
        now = ''
        res_address = self.value
        return begin, now, res_address


class StringStatement:
    def __init__(self, tokens):
        self.value = tokens[0][0][1:-1]

    def build_tree(self):
        return "'" + self.value + "'"

    def get_vars(self):
        return []


    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        begin = ''
        now = ''
        res_address = '"' + self.value + '"'
        return begin, now, res_address

    def assemble_final(self, res_address):
        begin = ''
        now = ''
        res_address = '"' + self.value + '"'
        return begin, now, res_address


def index(list1, el1):
    try:
        return list1.index(el1)
    except ValueError:
        return -1


def union(list1):
    res = []
    for el in list1:
        if type(el) == type(list()):
            res += el
        else:
            res += [el]
    return res


class OperatorStatement:
    def __init__(self, tokens):
        self.op = tokens[0]

    def build_tree(self):
        return 'OP(' + self.op + ')'

    def get_vars(self):
        return []

    def get_numbers(self):
        return []

    def send_GA(self, GA):
        self.GA = GA


class VarStatement:
    def __init__(self, tokens):
        self.name = tokens[0][0]

    def build_tree(self):
        return 'Var:' + self.name

    def get_vars(self):
        return [self.name]

    def get_numbers(self):
        return []

    def send_GA(self, GA):
        self.GA = GA

    def assemble(self):
        return '', '', 'DWORD PTR ' + self.GA.variable_address(self.name)

    def assemble_final(self, ra):
        return '', f'mov EDX, DWORD PTR {self.GA.variable_address(self.name)} ;Извлекаем в регистр для меньшего ' \
                   f'количества багов\n' + \
               f'mov {ra}, EDX ;Дада, запихиваем зачем-то снова', ra


def PreStatement(tokens):
    # print('DEBUG:PreSTATEMENT:TOKENS:', tokens)
    if tokens[0][0].isdigit():
        return NumberStatement(tokens)
    if tokens[0][1] == 'STRING':
        return StringStatement(tokens)
    else:
        return VarStatement(tokens)


class ArithmeticStatement:
    def __init__(self, tokens):
        self.tokens = tokens
        self.statements = []
        i = 0
        nesting_depth = 0
        statement_begin = 0

        while i < len(self.tokens):
            if self.tokens[i] == ('(', RESERVED):
                nesting_depth += 1
            if self.tokens[i] == (')', RESERVED):
                nesting_depth -= 1

            if self.tokens[i] == ('[', RESERVED):
                nesting_depth += 1

            if self.tokens[i] == (']', RESERVED):
                nesting_depth -= 1

            if self.tokens[i] == ('(', RESERVED) and nesting_depth == 1:
                statement_begin = i

            #            if (i - 1) < len(self.tokens) and nesting_depth == 0 and self.tokens[i][1] == 'ID' and self.tokens[
            #                i + 1] == ('[', RESERVED):
            #                statement_begin = i

            #            if self.tokens[i] == (']', RESERVED) and nesting_depth == 0:
            #                self.statements.append(tokens[statement_begin:i + 1])

            elif self.tokens[i] == (')', RESERVED) and nesting_depth == 0:
                self.statements.append(tokens[statement_begin:i + 1])


            elif nesting_depth == 0:
                self.statements.append(tokens[i])
            i += 1

        # print('DEBUG:ARITHMETIC:STATEMENTS', self.statements)

        index_add = index(self.statements, (ADD, RESERVED))
        index_min = index(self.statements, (MINUS, RESERVED))
        index_div = index(self.statements, (DIV, RESERVED))
        index_mul = index(self.statements, (MUL, RESERVED))

        # print('DEBUG:ARITHMETIC:POSITION:', index_add, index_min, index_div, index_mul)

        self.statement1 = None
        self.statement2 = None
        self.operator = None

        if index_add != -1:
            # print('DEBUG:ADD:')
            self.statement1 = union(self.statements[:index_add])
            self.statement2 = union(self.statements[index_add + 1:])
            self.operator = self.statements[index_add]
        elif index_min != -1:
            # print('DEBUG:MIN:')
            self.statement1 = union(self.statements[:index_min])
            self.statement2 = union(self.statements[index_min + 1:])
            self.operator = self.statements[index_min]
        elif index_div != -1:
            # print('DEBUG:DIV:')
            self.statement1 = union(self.statements[:index_div])
            self.statement2 = union(self.statements[index_div + 1:])
            self.operator = self.statements[index_div]
        elif index_mul != -1:
            # print('DEBUG:MUL:')
            self.statement1 = union(self.statements[:index_mul])
            self.statement2 = union(self.statements[index_mul + 1:])
            self.operator = self.statements[index_mul]
            # print('DEBUG:ARITHMETIC:S1:S2:OP:', self.statement1, self.statement2, self.operator)
        else:
            raise RuntimeError('чето нет оператора', self.tokens)

        self.statement1 = ConditionStatement(self.statement1)
        self.statement2 = ConditionStatement(self.statement2)
        self.operator = OperatorStatement(self.operator)

    def build_tree(self):
        return 'ArithmeticStatement(' + self.statement1.build_tree() + '~' + self.operator.build_tree() + \
               '~' + self.statement2.build_tree() + ')'

    def get_vars(self):
        return self.statement1.get_vars() + self.statement2.get_vars()

    def get_numbers(self):
        return self.statement1.get_numbers() + self.statement2.get_numbers()

    def send_GA(self, GA):
        self.statement1.send_GA(GA)
        self.statement2.send_GA(GA)
        self.GA = GA

    def assemble(self):
        b1, n1, r1 = self.statement1.assemble()
        b2, n2, r2 = self.statement2.assemble()
        res_address = self.GA.arith_address
        begin = b1 + '\n' + b2 + f'\n{res_address} dq ?'
        now1 = n1 + '\n' * min(len(n1), 1) + n2 + '\n' * min(len(n1), 1)
        now2 = ''
        if OPERATORS[self.operator.op] == 'add':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
add EAX, EBX ; складываем
mov DWORD PTR {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        if OPERATORS[self.operator.op] == 'mul':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
imul EBX ; перемножаем - результат в EAX
mov DWORD PTR {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        if OPERATORS[self.operator.op] == 'add':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
sub EAX, EBX ; вычитаем 
mov DWORD PTR {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        if OPERATORS[self.operator.op] == 'div':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
mov EDX, 0; вы все боты - хаха
idiv EBX ; делим - результат в EAX
mov DWORD PTR {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        return begin, now1 + '\n' + now2, 'DWORD PTR ' + res_address

    def assemble_final(self, res_address):
        b1, n1, r1 = self.statement1.assemble()
        b2, n2, r2 = self.statement2.assemble()
        begin = b1 + '\n' + b2
        now1 = n1 + '\n' * min(len(n1), 1) + n2 + '\n' * min(len(n1), 1)
        now2 = ''
        if OPERATORS[self.operator.op] == 'add':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
add EAX, EBX ; складываем
mov {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        if OPERATORS[self.operator.op] == 'mul':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
imul EBX ; перемножаем - результат в EAX
mov {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        if OPERATORS[self.operator.op] == 'sub':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
sub EAX, EBX ; вычитаем 
mov {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        if OPERATORS[self.operator.op] == 'div':
            now2 = f"""mov EAX, {r1}; переносим значение первого выражения в регистр
mov EBX, {r2} ; переносим значение второго выражения в регистр
mov EDX, 0; вы все боты
idiv EBX ; делим - результат в EAX
mov {res_address}, EAX ; переносим из регистра в ячейку памяти - результат"""
        return begin, now1 + '\n' + now2, res_address


"""
class ItemStatement:

    def __init__(self, tokens):
        self.tokens = tokens
        self.name = tokens[0][0]
        self.condition = tokens[2:-1]
        self.condition = ConditionStatement(self.condition)

    def get_vars(self):
        return [self.name] + self.condition.get_vars()

    def get_numbers(self):
        return self.condition.get_numbers()

    def send_GA(self, GA):
        self.condition.send_GA(GA)
        self.GA = GA

    def assemble(self):
        b, n, ra = self.condition.assemble()


class ArrayStatement:

    def __init__(self, tokens):
        self.name = tokens[1][0]
        self.length = int(tokens[2][0])
        self.tokens = tokens

    def get_vars(self):
        return [self.name]

    def get_numbers(self):
        return [self.length]

    def send_GA(self, GA):
        self.GA = GA
        self.address = self.GA.array_address(self.length)
"""


def ConditionStatement(tokens):
    # print('DEBUG:ConditionStatement:tokens:', tokens)
    if len(tokens) == 1:
        return PreStatement(tokens)
    while ('(', RESERVED) in tokens:
        i = 0
        nesting_depth = 0
        while nesting_depth > 0 or i == 0:
            if tokens[i][0] == '(':
                nesting_depth += 1
            if tokens[i][0] == ')':
                nesting_depth -= 1
            i += 1
        if i == len(tokens):
            tokens = tokens[1:-1]
        else:
            break
    if len(tokens) == 1:
        return PreStatement(tokens)
    # if tokens[-1][0] == ']':
    #    return ItemStatement(tokens)
    return ArithmeticStatement(tokens)


def isBoolOperatorIn(tokens):
    if (EQUALS, RESERVED) in tokens:
        return True
    if (GOE, RESERVED) in tokens:
        return True
    if (LOE, RESERVED) in tokens:
        return True
    if (GREATER, RESERVED) in tokens:
        return True
    if (LESS, RESERVED) in tokens:
        return True
    if (AND, RESERVED) in tokens:
        return True
    if (OR, RESERVED) in tokens:
        return True
    if ('!=', 'RESERVED') in tokens:
        return True
    return False


def BoolConditionStatement(tokens):
    while ('(', RESERVED) in tokens:
        i = 0
        nesting_depth = 0
        while nesting_depth > 0 or i == 0:
            if tokens[i][0] == '(':
                nesting_depth += 1
            if tokens[i][0] == ')':
                nesting_depth -= 1
            i += 1
        if i == len(tokens):
            tokens = tokens[1:-1]
        else:
            break
    if (OR, RESERVED) in tokens:
        return BoolLogicConditionStatement(tokens)
    if (AND, RESERVED) in tokens:
        return BoolLogicConditionStatement(tokens)
    if (EQUALS, RESERVED) in tokens:
        return BoolCMPConditionStatement(tokens)
    if (GOE, RESERVED) in tokens:
        return BoolCMPConditionStatement(tokens)
    if (LOE, RESERVED) in tokens:
        return BoolCMPConditionStatement(tokens)
    if (GREATER, RESERVED) in tokens:
        return BoolCMPConditionStatement(tokens)
    if (LESS, RESERVED) in tokens:
        return BoolCMPConditionStatement(tokens)
    if ('!=', 'RESERVED') in tokens:
        return BoolCMPConditionStatement(tokens)
    return False


class BoolLogicConditionStatement:
    def __init__(self, tokens):
        print('gg')
        self.tokens = tokens
        # if not isBoolOperatorIn(tokens):
        #    raise RuntimeWarning('нету операторов логических', tokens)
        self.statements = []
        i = 0
        nesting_depth = 0
        statement_begin = 0

        while i < len(self.tokens):
            if self.tokens[i] == ('(', RESERVED):
                nesting_depth += 1
            if self.tokens[i] == (')', RESERVED):
                nesting_depth -= 1

            if self.tokens[i] == ('(', RESERVED) and nesting_depth == 1:
                statement_begin = i

            if self.tokens[i] == (')', RESERVED) and nesting_depth == 0:
                self.statements.append(tokens[statement_begin:i + 1])

            elif nesting_depth == 0:
                self.statements.append(tokens[i])
            i += 1

        index_or = index(self.statements, (OR, RESERVED))
        index_and = index(self.statements, (AND, RESERVED))

        if index_or != -1:
            # print('DEBUG:OR:')
            self.statement1 = union(self.statements[:index_or])
            self.statement2 = union(self.statements[index_or + 1:])
            self.operator = self.statements[index_or]

        elif index_and != -1:
            # print('DEBUG:AND:')
            self.statement1 = union(self.statements[:index_and])
            self.statement2 = union(self.statements[index_and + 1:])
            self.operator = self.statements[index_and]

        else:
            raise RuntimeError('нету операторов', self.tokens)

        if isBoolOperatorIn(self.statement1):
            self.statement1 = BoolConditionStatement(self.statement1)
        else:
            self.statement1 = ConditionStatement(self.statement1)

        if isBoolOperatorIn(self.statement2):
            self.statement2 = BoolConditionStatement(self.statement2)
        else:
            self.statement2 = ConditionStatement(self.statement2)

        self.operator = OperatorStatement(self.operator)

    def build_tree(self):
        return 'BoolConditionStatement(' + self.statement1.build_tree() + '~' + self.operator.build_tree() + '~' + self.statement2.build_tree() + ')'

    def get_vars(self):
        return self.statement1.get_vars() + self.statement2.get_vars()

    def get_numbers(self):
        return self.statement1.get_numbers() + self.statement2.get_numbers()

    def send_GA(self, GA):
        self.statement1.send_GA(GA)
        self.statement2.send_GA(GA)
        self.GA = GA

    def assemble(self):
        b1, n1, r1 = self.statement1.assemble()
        b2, n2, r2 = self.statement2.assemble()
        res_address = self.GA.bool_address
        begin = b1 + '\n' + b2 + f'\n{res_address} dq ?'
        op = self.operator.op
        nb = n1 + '\n' * min(len(n1), 1) + n2 + '\n' * min(len(n1), 1)
        now = ''
        print('DEBUG:OP', op)
        if op == 'или':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
or EAX, EBX
mov DWORD PTR {res_address}, EAX'''
        elif op == 'и':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
and EAX, EBX
mov DWORD PTR {res_address}, EAX'''

        now = nb + now
        return begin, now, 'DWORD PTR ' + res_address

    def assemble_final(self, res_address):
        b1, n1, r1 = self.statement1.assemble()
        b2, n2, r2 = self.statement2.assemble()
        begin = b1 + '\n' + b2 + f''
        op = self.operator.op
        nb = n1 + '\n' * min(len(n1), 1) + n2 + '\n' * min(len(n1), 1)
        now = ''
        # print('DEBUG:OP', op)
        if op == 'или':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
or EAX, EBX
mov {res_address}, EAX'''
        elif op == 'и':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
and EAX, EBX
mov {res_address}, EAX'''

        now = nb + now
        return begin, now, res_address


class BoolCMPConditionStatement:
    def __init__(self, tokens):
        self.tokens = tokens
        if not isBoolOperatorIn(tokens):
            raise RuntimeWarning('нету операторов логических', tokens)
        self.statements = []
        i = 0
        nesting_depth = 0
        statement_begin = 0

        while i < len(self.tokens):
            if self.tokens[i] == ('(', RESERVED):
                nesting_depth += 1
            if self.tokens[i] == (')', RESERVED):
                nesting_depth -= 1

            if self.tokens[i] == ('(', RESERVED) and nesting_depth == 1:
                statement_begin = i

            if self.tokens[i] == (')', RESERVED) and nesting_depth == 0:
                self.statements.append(tokens[statement_begin:i + 1])

            elif nesting_depth == 0:
                self.statements.append(tokens[i])
            i += 1

        index_ls = index(self.statements, (LESS, RESERVED))
        index_gr = index(self.statements, (GREATER, RESERVED))
        index_goe = index(self.statements, (GOE, RESERVED))
        index_loe = index(self.statements, (LOE, RESERVED))
        index_eq = index(self.statements, (EQUALS, RESERVED))
        index_not_eq = index(self.statements, (NOT_EQUALS, RESERVED))

        if index_gr != -1:
            # print('DEBUG:GR:')
            self.statement1 = union(self.statements[:index_gr])
            self.statement2 = union(self.statements[index_gr + 1:])
            self.operator = self.statements[index_gr]

        elif index_ls != -1:
            # print('DEBUG:LS:')
            self.statement1 = union(self.statements[:index_ls])
            self.statement2 = union(self.statements[index_ls + 1:])
            self.operator = self.statements[index_ls]

        elif index_goe != -1:
            # print('DEBUG:GOE:')
            self.statement1 = union(self.statements[:index_goe])
            self.statement2 = union(self.statements[index_goe + 1:])
            self.operator = self.statements[index_goe]

        elif index_loe != -1:
            # print('DEBUG:LOE:')
            self.statement1 = union(self.statements[:index_loe])
            self.statement2 = union(self.statements[index_loe + 1:])
            self.operator = self.statements[index_loe]

        elif index_eq != -1:
            # print('DEBUG:EQ:')
            self.statement1 = union(self.statements[:index_eq])
            self.statement2 = union(self.statements[index_eq + 1:])
            self.operator = self.statements[index_eq]
        elif index_not_eq != -1:
            # print('DEBUG:EQ:')
            self.statement1 = union(self.statements[:index_not_eq])
            self.statement2 = union(self.statements[index_not_eq + 1:])
            self.operator = self.statements[index_not_eq]

        else:
            raise RuntimeError('нету операторов', self.tokens)

        if isBoolOperatorIn(self.statement1):
            self.statement1 = BoolConditionStatement(self.statement1)
        else:
            self.statement1 = ConditionStatement(self.statement1)

        if isBoolOperatorIn(self.statement2):
            self.statement2 = BoolConditionStatement(self.statement2)
        else:
            self.statement2 = ConditionStatement(self.statement2)

        self.operator = OperatorStatement(self.operator)

    def build_tree(self):
        return 'BoolConditionStatement(' + self.statement1.build_tree() + '~' + self.operator.build_tree() + '~' + self.statement2.build_tree() + ')'

    def get_vars(self):
        return self.statement1.get_vars() + self.statement2.get_vars()

    def get_numbers(self):
        return self.statement1.get_numbers() + self.statement2.get_numbers()

    def send_GA(self, GA):
        self.statement1.send_GA(GA)
        self.statement2.send_GA(GA)
        self.GA = GA

    def assemble(self):
        b1, n1, r1 = self.statement1.assemble()
        b2, n2, r2 = self.statement2.assemble()
        res_address = self.GA.bool_address
        begin = b1 + '\n' + b2 + '\n' + f'{res_address} dq ?'
        op = self.operator.op
        now = ''
        nb1 = n1 + '\n' * min(len(n1), 1) + n2 + '\n' * min(len(n1), 1)
        # print('DEBUG:OP', op)
        n1 = self.GA.bool_address
        n2 = self.GA.bool_address
        if op == '==':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jne next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov DWORD PTR {res_address}, ECX'''
        elif op == '!=':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
je next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov DWORD PTR {res_address}, ECX'''
        elif op == '>':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jng next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov DWORD PTR {res_address}, ECX'''
        elif op == '<':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jnl next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov DWORD PTR {res_address}, ECX'''
        elif op == '>=':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jnge next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov DWORD PTR {res_address}, ECX'''
        elif op == '<=':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jnle next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov DWORD PTR {res_address}, ECX'''

        return begin, nb1 + now, 'DWORD PTR ' + res_address

    def assemble_final(self, res_address):
        b1, n1, r1 = self.statement1.assemble()
        b2, n2, r2 = self.statement2.assemble()
        begin = b1 + '\n' + b2
        op = self.operator.op
        now = ''
        nb1 = n1 + '\n' * min(len(n1), 1) + n2 + '\n' * min(len(n1), 1)
        # print('DEBUG:OP', op)
        n1 = self.GA.bool_address
        n2 = self.GA.bool_address
        if op == '==':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jne next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov {res_address}, ECX'''
        elif op == '!=':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
je next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov {res_address}, ECX'''
        elif op == '>':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jng next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov {res_address}, ECX'''
        elif op == '<':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jnl next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov {res_address}, ECX'''
        elif op == '>=':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jnge next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov {res_address}, ECX'''
        elif op == '<=':
            now = f'''mov EAX, {r1}
mov EBX, {r2}
cmp EAX, EBX
jnle next_{n1}
mov ECX, 1
jmp next_{n2}
next_{n1}:
mov ECX, 0
next_{n2}:
mov {res_address}, ECX'''

        return begin, nb1 + now, res_address


class BlockStatement:
    def __init__(self, tokens):
        self.block_begin = tokens.index((BLOCK_BEGIN, RESERVED))
        self.block_tokens = tokens[self.block_begin + 1:len(tokens) - 1]
        self.condition = tokens[1:self.block_begin]
        self.condition = BoolConditionStatement(self.condition)
        self.statement = Statement(self.block_tokens)

    def get_vars(self):
        return self.condition.get_vars() + self.statement.get_vars()

    def get_numbers(self):
        return self.condition.get_numbers() + self.statement.get_numbers()

    def send_GA(self, GA):
        self.condition.send_GA(GA)
        self.statement.send_GA(GA)
        self.GA = GA


class WhileStatement(BlockStatement):
    def build_tree(self):
        return 'WhileStatement(' + self.condition.build_tree() + ', ' + self.statement.build_tree() + ')'

    def assemble(self):
        bs1, ns1 = self.statement.assemble()
        bc, nc, ra = self.condition.assemble_final('EAX')
        n_next = self.GA.bool_address
        now = f"""while_label{n_next}:
{nc}
cmp EAX, 1
jne while_next{n_next}
{ns1}
jmp while_label{n_next}
while_next{n_next}:
"""
        begin = bc + '\n' + bs1 + '\n'
        return begin, now


class OnlyIfStatement(BlockStatement):
    def build_tree(self):
        return 'OnlyIfStatement(' + self.condition.build_tree() + ', ' + self.statement.build_tree() + ')'

    def assemble(self):
        bs1, ns1 = self.statement.assemble()
        bc, nc, ra = self.condition.assemble()
        not_adr = self.GA.bool_address
        n1 = len(ns1.split('\n')) + 1
        label_next = self.GA.bool_address
        now = f"""{nc}
mov EAX, {ra}
cmp EAX, 1
jne next{label_next}
{ns1}
next{label_next}:
"""
        begin = bc + '\n' + bs1
        return begin, now


class IfElseStatement:
    def __init__(self, tokens):
        print('DEBUG:', tokens)
        self.tokens = tokens
        self.block_begin = tokens.index((BLOCK_BEGIN, RESERVED))
        self.block1_end = 0
        nesting_lvl = 0
        for token in tokens:
            if token[0] == BLOCK_BEGIN:
                nesting_lvl += 1
            if token[0] == BLOCK_END:
                nesting_lvl -= 1
                if nesting_lvl < 1:
                    break
            self.block1_end += 1
        print('DEBUG:', tokens, self.block1_end)
        self.block1_tokens = tokens[self.block_begin + 1:self.block1_end]
        print('DEBUG:', self.block1_tokens)
        self.block2_begin = tokens.index((BLOCK_BEGIN, RESERVED), self.block1_end)
        self.block2_tokens = tokens[self.block2_begin + 1:len(tokens) - 1]
        self.condition = tokens[1:self.block_begin]
        self.condition = BoolConditionStatement(self.condition)
        self.statement1 = Statement(self.block1_tokens)
        self.statement2 = Statement(self.block2_tokens)

    def build_tree(self):
        return 'IfElseStatement(' + self.condition.build_tree() + ', ' + \
               self.statement1.build_tree() + ', ' + self.statement2.build_tree() + ')'

    def get_vars(self):
        return self.condition.get_vars() + self.statement1.get_vars() + self.statement2.get_vars()

    def get_numbers(self):
        return self.condition.get_numbers() + self.statement1.get_numbers() + self.statement2.get_numbers()

    def send_GA(self, GA):
        self.condition.send_GA(GA)
        self.statement1.send_GA(GA)
        self.statement2.send_GA(GA)
        self.GA = GA

    def assemble(self):
        bs1, ns1 = self.statement1.assemble()
        bs2, ns2 = self.statement2.assemble()
        bc, nc, ra = self.condition.assemble()
        not_adr = self.GA.bool_address
        n1 = len(ns1.split('\n')) + 1
        n2 = len(ns2.split('\n')) + 1
        lne1 = self.GA.bool_address
        ln = self.GA.bool_address
        now = f"""{nc}
mov EAX, {ra}
cmp EAX, 1
jne next_else{lne1}
{ns1}
jmp next_{ln}
next_else{lne1}:
{ns2}
next_{ln}:"""
        begin = bc + '\n' + bs1 + '\n' + bs2
        return begin, now


class Statement:  # дерево по ; и {}

    def __init__(self, tokens):

        self.statements = []
        self.tokens = tokens

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
                    tokens2 = tokens[part_begin:index]
                    if tokens2[0][0] == WHILE:
                        self.statements.append(WhileStatement(tokens2))
                    elif tokens2[0][0] == IF:
                        self.statements.append(IfStatement(tokens2))
                    else:
                        self.statements.append(LowLevelStatement(tokens2))
                    part_begin = index + 1
                    index += 1
                    continue
            if tokens[index][1] == RESERVED:
                if tokens[index][0] == BLOCK_BEGIN:
                    nesting_lvl += 1
                elif tokens[index][0] == BLOCK_END:
                    nesting_lvl -= 1
            index += 1

    def build_tree(self):

        return 'Statement(' + ';'.join(list(map((lambda a: a.build_tree()), self.statements))) + ')'

    def get_vars(self):
        res = []
        for s in self.statements:
            res += s.get_vars()
        return list(set(res))

    def get_numbers(self):
        res = []
        for s in self.statements:
            res += s.get_numbers()
        return list(set(res))

    def send_GA(self, GA):
        for s in self.statements:
            s.send_GA(GA)
        self.GA = GA

    def assemble(self):
        begin = ''
        now = ''
        for s in self.statements:
            b, n = s.assemble()
            begin += '\n' + b
            now += '\n' + n
        if len(now) > 0: now = now[1:]
        if len(begin) > 0: begin = begin[1:]
        return begin, now


class IncludeCode(Statement):
    def __init__(self, tokens):
        self.tkns = tokens
        self.filename = self.tkns[0][0][10:]
        self.chars = open(self.filename, encoding='utf-8').read()
        print(self.chars)
        self.tokens = imp_lexer.imp_lex(self.chars)
        self.statements = []
        tokens = self.tokens

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
                    tokens2 = tokens[part_begin:index]
                    if tokens2[0][0] == WHILE:
                        self.statements.append(WhileStatement(tokens2))
                    elif tokens2[0][0] == IF:
                        self.statements.append(IfStatement(tokens2))
                    else:
                        self.statements.append(LowLevelStatement(tokens2))
                    part_begin = index + 1
                    index += 1
                    continue
            if tokens[index][1] == RESERVED:
                if tokens[index][0] == BLOCK_BEGIN:
                    nesting_lvl += 1
                elif tokens[index][0] == BLOCK_END:
                    nesting_lvl -= 1
            index += 1
    def build_tree(self):

        return 'IncludeCodeStatement(' + ';'.join(list(map((lambda a: a.build_tree()), self.statements))) + ')'


def IfStatement(tokens):  # Эмулятop клacca - выбoр мeжду 2 типaми if и if-else
    nesting_lvl = 0
    block1_end = 0
    for token in tokens:
        if token[0] == BLOCK_BEGIN:
            nesting_lvl += 1
        if token[0] == BLOCK_END:
            nesting_lvl -= 1
            if nesting_lvl == 0:
                break
        block1_end += 1

    # print('DEBUG:', block1_end, tokens)
    # print(tokens.index((BLOCK_END, RESERVED)))

    if block1_end == (len(tokens) - 1):
        return OnlyIfStatement(tokens)
    else:
        return IfElseStatement(tokens)


def pass_func(x):
    return x
