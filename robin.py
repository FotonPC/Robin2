import sys, parse, ro_asm_compiler, make_exe, imp_lexer, subprocess, os, shutil

def main():
    if len(sys.argv) != 2:
        filename = input('Введите название файла:')
    else:
        filename = sys.argv[1]
    robin_directory = os.getcwd()
    file_directory = '\\'.join(filename.split('\\')[:-1])
    if file_directory == '':
        file_directory = robin_directory
    text = open(filename, encoding='utf-8').read()
    print('[Программа загружена]')
    tokens = imp_lexer.imp_lex(text)
    print(tokens)
    print('[Программа лексирована]')
    os.chdir(file_directory)
    #print(tokens)
    parse_result = parse.Statement(tokens=tokens)
    print('[Программа распарсена]')
    robin_assembler = ro_asm_compiler.make_asm(parse_result)
    print('[Программа собрана в MASM]')
    print(robin_assembler)
    with open(filename.split('.')[-2].split('\\')[-1]+'.masm', 'w+') as f:
        f.write(robin_assembler)
    os.chdir(robin_directory)
    make_exe.main(filename.split('.')[-2].split('\\')[-1]+'.masm')
    print('[Программа запущена]')
    subprocess.call([filename.split(".")[0]+".exe"])
    input('[Программа завершена]')

if __name__ == '__main__':
    main()
