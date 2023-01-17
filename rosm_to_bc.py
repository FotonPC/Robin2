import pickle

def smart_spl(x):
    return x.split(';')[0]


def load(text):
    strings = list(map(smart_spl, text.split('\n')))
    data = list(map(lambda x: x.split(':'), strings))
    data2 = list(map(lambda x: x[0], data))
    data = list(map(lambda x: list(map(int, x[1:])) if x[0] != 'setval' else x[1:], data))
    data += data
    return data, data2

def load_to_file(file_in, file_out):
    text = open(file_in).read()
    dates = load(text)
    with open(file_out, "wb") as f:
        pickle.dump(dates, f)

if __name__ == '__main__':
    load_to_file('hello.roasm', 'hello.rabin')