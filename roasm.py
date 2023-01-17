import warnings
warnings.filterwarnings('ignore')
import numba, numpy, pickle


"""
# # @numba.jit(cache=True)
def exec(data=None, data2=None, memory=None):
    current_string = 0
    while current_string < len(data2):
        # print('DEBUG:', current_string, data2[current_string], data[current_string])

        if data2[current_string] == 'ifgotofwd':
            if memory[int(data[current_string][1])]:
                current_string += int(data[current_string][0])
                continue
        if data2[current_string] == 'gotoback':
            current_string -= int(data[current_string][0])
            continue
        elif data2[current_string] == 'define':
            define(int(data[current_string][0]), memory=memory)
        elif data2[current_string] == 'setval':
            setval(int(data[current_string][0]), int(data[current_string][1]), memory=memory)
        elif data2[current_string] == 'add':
            add(int(data[current_string][0]), int(data[current_string][1]),
                int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'mul':
            mul(int(data[current_string][0]), int(data[current_string][1]),
                int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'div':
            div(int(data[current_string][0]), int(data[current_string][1]),
                int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'sub':
            sub(int(data[current_string][0]), int(data[current_string][1]),
                int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'gre':
            gre(int(data[current_string][0]), int(data[current_string][1]),
                int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'eql':
            eql(int(data[current_string][0]), int(data[current_string][1]),
                int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'and':
            and_op(int(data[current_string][0]), int(data[current_string][1]),
                   int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'or':
            or_op(int(data[current_string][0]), int(data[current_string][1]),
                  int(data[current_string][2]), memory=memory)
        elif data2[current_string] == 'not':
            not_op(int(data[current_string][0]), int(data[current_string][1]), memory=memory)
        elif data2[current_string] == 'print':
            print_func(int(data[current_string][0]), memory=memory)
        elif data2[current_string] == 'input':
            # print('DEBUG:INPUT')
            input_func(int(data[current_string][0]), memory=memory)
        current_string += 1
"""


# @numba.jit(cache=True)
def input_func(adress, pass1, pass2, pass3, pass4, memory=None):
    setval(adress, int(input('Ввод: ')), pass1, pass2, pass3, memory=memory)


@numba.njit(cache=True)
def print_func(adress, pass1, pass2, pass3, pass4, memory=None):
    print(memory[adress])


# @numba.njit(cache=True)
def graphic(data=None, memory=None):
    pass


# @numba.njit(cache=True)
def console(pass0, pass1, pass2, pass3, pass4, memory=None):
    pass


# @numba.njit(cache=True)
def setpixel(x, y, r, g, b, memory=None):
    pass


@numba.njit(cache=True)
def define(adress, size, pass2, pass3, pass4, memory=None):
    memory[adress] = 0


def setval(adress, value, pass2, pass3, pass4, memory=None):
    if value[0] == '*':
        value = memory[memory[int(value[1:])]]
    if adress[0] == '*':
        memory[memory[int(adress[1:])]] = value



@numba.njit(cache=True)
def add(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = memory[adr1] + memory[adr2]


@numba.njit(cache=True)
def mul(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = memory[adr1] * memory[adr2]



@numba.njit(cache=True)
def sub(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = memory[adr1] - memory[adr2]


@numba.njit(cache=True)
def div(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = memory[adr1] // memory[adr2]


@numba.njit(cache=True)
def gre(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = int(memory[adr1] > memory[adr2])


@numba.njit(cache=True)
def eql(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = int(memory[adr1] == memory[adr2])


@numba.njit(cache=True)
def or_op(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = int(memory[adr1] or memory[adr2])


@numba.njit(cache=True)
def and_op(adr1, adr2, adr_out, pass3, pass4, memory=None):
    memory[adr_out] = int(memory[adr1] and memory[adr2])


@numba.njit(cache=True)
def not_op(adr1, adr_out, pass2, pass3, pass4, memory=None):
    memory[adr_out] = int(not bool(memory[adr1]))

@numba.njit(cache=True)
def ifgotofwd(steps, param_adress, pass1, pass2, pass3, memory=None):
    if memory[param_adress]:
        memory[0] += steps - 1

@numba.njit(cache=True)
def gotoback(steps, pass0, pass1, pass2, pass3, memory=None, current_string=None):
    memory[0] -= steps + 1


functions = {'ifgotofwd': ifgotofwd, 'gotoback': gotoback, 'define': define, 'setval': setval, 'add': add, 'mul': mul,
             'div': div, 'sub': sub, 'gre': gre, 'eql': eql, 'and': and_op, 'or': or_op, 'not': not_op,
             'print': print_func, 'input': input_func}


def exec(data=None, data2=None, memory=None):
    while memory[0] < len(data2):
        #print('DEBUG:', memory[0], data2[memory[0]], data[memory[0]])
        functions[data2[memory[0]]](*data[memory[0]], memory=memory)
        memory[0] += 1


def main(filename):
    with open(filename, "rb") as f:
        data, data2 = pickle.load(f)
    memory = numpy.zeros(1024, 'int')
    print("[Программа запущена]")
    exec(data, data2, memory)

if __name__ == '__main__':
    with open(input('Введите имя файла:'), "rb") as f:
        data, data2 = pickle.load(f)
    memory = numpy.zeros(1024, 'int')
    print("[Программа запущена]")
    exec(data, data2, memory)
