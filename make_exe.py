import sys, os, shutil

def main(filename):
    files = os.listdir('masm32\\include')
    robin_dir = os.getcwd()
    for file in files:
        if not file in os.listdir('.' if "\\".join(filename.split('\\')[:-1:]) == '' else "\\".join(filename.split('\\')[:-1:]) ):

            shutil.copy(file, "\\".join(filename.split('\\')[:-1:])+'\\'*len("\\".join(filename.split('\\')[:-1:]))+file)
    fc = os.system(f'''{robin_dir}\\masm32\\bin\\ml /c /coff {filename}''')
    fc2 = os.system(f'{robin_dir}\\masm32\\bin\\link /subsystem:console {filename.split(".")[0]}.obj')
    if fc == fc2 == 0:
        print('[Все прошло успешно]')
        print('['+filename.split('.')[-2].split('\\')[-1]+'.exe'+']')
    else:
        print('[Ошибка сборки OBJ файла]')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        filename = input()
    else:
        filename = sys.argv[1]
    fc = os.system(f'''masm32\\bin\\ml /c /coff {filename}''')
    fc2 = os.system(f'masm32\\bin\\link /subsystem:console {filename.split(".")[0]}.obj')
    if fc == 0:
        print('[Все прошло успешно]')
        print('['+filename.split(".")[0]+".exe"+']')
    else:
        print('[MASM ROBIN FAILURE]')
