class GetAddress:
    def __init__(self):
        self.i_a = 11
        self.i_b = 12
        self.v_c = {}
        self.c_v = {}
        self.n_c = {}
        self.c_n = {}
        self.all_addresses = []
        self.a_c = {}
        self.includes = ['console.inc']

    @property
    def bool_address(self):
        self.i_b += 10
        self.all_addresses += [self.i_b]
        return 'bool_var_' + str(self.i_b)

    def append_include(self, fn):
        self.includes.append(fn)
        self.includes = list(set(self.includes))

    @property
    def arith_address(self):
        self.i_a += 10
        self.all_addresses += [self.i_b]
        return 'math_var_' + str(self.i_a)

    def set_vars_list(self, v_c, c_v):
        self.v_c = v_c
        self.c_v = c_v
        self.all_addresses += list(self.c_v.keys())

    def set_nums_list(self, n_c, c_n):
        self.n_c = n_c
        self.c_n = c_n
        self.all_addresses += list(self.c_n.keys())

    def number_address(self, num):
        return self.n_c[num]

    def variable_address(self, var):
        return self.v_c[var]

    def array_address(self, length, name):
        m = max(self.all_addresses)
        for i in range(m + 1, m + 1 + length):
            self.all_addresses += [i]
        self.i_a = (max(self.all_addresses) // 10) * 11 + 1
        self.i_b = (max(self.all_addresses) // 10) * 11 + 2
        self.a_c[name] = m + 1
        return m + 1

    def get_arr_a(self, name):
        return self.a_c[name]


def make_asm(statement):
    all_vars = statement.get_vars()
    code_vars = {}
    vars_code = {}
    adder_c = 10
    for var in all_vars:
        code_vars['user_var_' + str(adder_c)] = var
        vars_code[var] = 'user_var_' + str(adder_c)
        adder_c += 10

    GA = GetAddress()
    GA.set_vars_list(vars_code, code_vars)
    statement.send_GA(GA)
    asm = statement.assemble()
    begin = asm[0]
    for num in list(set(all_vars)):
        begin += f'\n{vars_code[num]} dq ?'
    strings = ('\n'.join(
        map(lambda x: 'include ' + x, GA.includes)) + '\n\n\n.data\n\n' + begin + '\n\n.code\n\nStart:\n' + asm[
                   1] + '\n\nexit\nend Start').split('\n')
    s1 = []
    for s in strings:
        if len(s) > 0:
            s1 += [s]
    assembler = '\n'.join(s1)

    return assembler
