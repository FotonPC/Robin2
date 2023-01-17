import sys, os, shutil
def copytree(src, dst, symlinks=False, ignore=None):
    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)
def main(filename):
    robin_dir = os.getcwd()
    file_dir = '\\'.join(filename.split("/")[:-1])
    try:
        copytree('masm32\\include', file_dir)
        copytree('masm32\\lib', file_dir )
        print('libs includes copied')
    except:
        print('project is created')
    os.chdir(file_dir)
    fc = os.system(f'''{robin_dir}\\masm32\\bin\\ml /c /coff "{filename}"''')
    fc2 = os.system(f'{robin_dir}\\masm32\\bin\\link /subsystem:console "{filename.split(".")[0]}.obj"')
    if fc == fc2 == 0:
        print('[Все прошло успешно]')
        print('['+filename.split('.')[-2].split('\\')[-1]+'.exe'+']')
    else:
        print('[Ошибка сборки OBJ файла]')
    os.chdir(robin_dir)

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
