import numba

"""
define:address:size64or32or8or1:0:0:0;
setval:address:value:0:0:0;
add:address1:address2:address_out:0:0;
mul:address1:address2:address_out:0:0;
div:address1:address2:address_out;0:0;
sub:address1:address2:address_out:0:0;
gre;eql;or;and;not;
ifgotofwd:steps:param:0:0:0;
setpixel:x:y:r:g:b;
gotoback:steps:0:0:0:0;
print:adress:0:0:0:0;
input:adress:0:0:0:0;


"""


def smart_spl(x):
    return x.split(';')[0]


class RoAsm:
    def __init__(self):
        self.memory = {}
        self.data = [['console', '0', '0', '0', '0', '0', '0', '0']]

    def load(self, text):
        strings = list(map(smart_spl, text.split('\n')))
        data = list(map(lambda x: x.split(':'), strings))
        self.data += data
    @numba.njit
    def exec(self):
        current_string = 0
        while current_string < len(self.data):
            # print('DEBUG:', current_string, self.data[current_string])

            if self.data[current_string][0] == 'ifgotofwd':
                if self.memory[int(self.data[current_string][2])]:
                    current_string += int(self.data[current_string][1])
                    continue
            if self.data[current_string][0] == 'gotoback':
                current_string -= int(self.data[current_string][1])
                continue
            elif self.data[current_string][0] == 'define':
                self.define(int(self.data[current_string][1]))
            elif self.data[current_string][0] == 'setval':
                self.setval(int(self.data[current_string][1]), int(self.data[current_string][2]))
            elif self.data[current_string][0] == 'add':
                self.add(int(self.data[current_string][1]), int(self.data[current_string][2]),
                         int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'mul':
                self.mul(int(self.data[current_string][1]), int(self.data[current_string][2]),
                         int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'div':
                self.div(int(self.data[current_string][1]), int(self.data[current_string][2]),
                         int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'sub':
                self.sub(int(self.data[current_string][1]), int(self.data[current_string][2]),
                         int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'gre':
                self.gre(int(self.data[current_string][1]), int(self.data[current_string][2]),
                         int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'eql':
                self.eql(int(self.data[current_string][1]), int(self.data[current_string][2]),
                         int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'and':
                self.and_op(int(self.data[current_string][1]), int(self.data[current_string][2]),
                            int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'or':
                self.or_op(int(self.data[current_string][1]), int(self.data[current_string][2]),
                           int(self.data[current_string][3]))
            elif self.data[current_string][0] == 'not':
                self.not_op(int(self.data[current_string][1]), int(self.data[current_string][2]))
            elif self.data[current_string][0] == 'print':
                self.print(int(self.data[current_string][1]))
            elif self.data[current_string][0] == 'input':
                # print('DEBUG:INPUT')
                self.input(int(self.data[current_string][1]))
            current_string += 1

    def input(self, adress):
        self.setval(adress, int(input()))

    def print(self, adress):
        print(self.memory[adress])

    def graphic(self):
        pass

    def console(self):
        pass

    def setpixel(self, x, y, r, g, b):
        pass

    def define(self, adress, size=0):
        self.memory[adress] = 0

    def setval(self, adress, value):
        self.memory[adress] = value

    def add(self, adr1, adr2, adr_out):
        self.memory[adr_out] = self.memory[adr1] + self.memory[adr2]

    def mul(self, adr1, adr2, adr_out):
        self.memory[adr_out] = self.memory[adr1] * self.memory[adr2]

    def sub(self, adr1, adr2, adr_out):
        self.memory[adr_out] = self.memory[adr1] - self.memory[adr2]

    def div(self, adr1, adr2, adr_out):
        self.memory[adr_out] = self.memory[adr1] // self.memory[adr2]

    def gre(self, adr1, adr2, adr_out):
        self.memory[adr_out] = int(self.memory[adr1] > self.memory[adr2])

    def eql(self, adr1, adr2, adr_out):
        self.memory[adr_out] = int(self.memory[adr1] == self.memory[adr2])

    def or_op(self, adr1, adr2, adr_out):
        self.memory[adr_out] = int(self.memory[adr1] or self.memory[adr2])

    def and_op(self, adr1, adr2, adr_out):
        self.memory[adr_out] = int(self.memory[adr1] and self.memory[adr2])

    def not_op(self, adr1, adr_out):
        self.memory[adr_out] = int(not bool(self.memory[adr1]))


if __name__ == '__main__':
    asm = RoAsm()
    asm.load("""define:10:0:0; создаем переменную
setval:1:1:0;
setval:0:0:0;
input:10:0:0;
define:11:0:0;
define:21:0:0;
define:31:0:0;
define:20:0:0;
setval:20:0:0;
gre:10:20:11;
eql:10:20:21;
or:21:11:31;
not:31:11:0;
not:11:21:0;
ifgotofwd:10:11:0;
print:20:0:0;
add:20:1:20;
gotoback:8:0:0;
add:0:0:20;
""")
    asm.exec()
