import json
import threading
import tkinter.messagebox
import tkinter as tk
import traceback
from tkinter import ttk, filedialog, simpledialog, messagebox
import ttkthemes
import make_exe
import os, sys
import parse, imp_lexer, ro_asm_compiler
import re

template_settings = {
  "interface_theme" : "yaru",
  "editor_theme" : "dark std",
  "compiler_theme" : "dark std",
  "editor_font" : ("Jetbrains Mono", 15)
}

code_lighting_theme_dark = {"RESERVED": {"foreground": "#ff0000"},
                            "ASM_CODE": {"foreground": "#00ff00"},
                            "ASM_DATA": {"foreground": '#00ee00'},
                            "ASM_INCLUDE": {"foreground": '#00dd00'},
                            "INCLUDE": {"foreground": '#00ccff'},
                            "INT": {"foreground": '#ff8800'},
                            "ID": {"foreground": '#eeeeaa'},
                            "STRING": {"foreground": '#00ff00'},
                            "KEYWORD2": {"foreground": '#ccccff'}
                            }
code_lighting_theme_light = {"RESERVED": {"foreground": "#aa0000"},
                             "ASM_CODE": {"foreground": "#00aa00"},
                             "ASM_DATA": {"foreground": '#007700'},
                             "ASM_INCLUDE": {"foreground": '#009900'},
                             "INCLUDE": {"foreground": '#0077aa'},
                             "INT": {"foreground": '#aa4400'},
                             "ID": {"foreground": '#444422'},
                             "STRING": {"foreground": '#00aa00'},
                             "KEYWORD2": {"foreground": '#8888aa'}
                             }

settings_json_path = "settings.json"


def exc_log(func=None):
    def res(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as error:
            window = tk.Tk()
            lines_s = '\n'.join(traceback.format_exception(*sys.exc_info()))
            tk.Label(window, text=f"""{error}
            {lines_s}
            main exception""").pack()
            window.mainloop()

    return res


class CodeStyleObj:
    @exc_log
    def __init__(self, bg="#333333", fg="#FFFFAA", font=('Jetbrains Mono', 18, 'bold'),
                 lighting_theme=None):
        if lighting_theme is None:
            lighting_theme = code_lighting_theme_dark
        self.bg = bg
        self.fg = fg
        self.font = font
        self.lighting = lighting_theme

    @exc_log
    def tkinter_get(self):
        return {"bg": self.bg, "fg": self.fg, 'font': self.font}

    @exc_log
    def tkinter_set_tags(self, txt):
        txt.code_lighting_theme = self.lighting
        txt.syntax_lighting_update()


class FileField(ttk.Frame):
    @exc_log
    def __init__(self, master, lighting=True):
        super().__init__(master)
        self.lighting = lighting
        self.master = master
        self.text = tk.Text(self, bg='#333333', fg='#FFFFAA', font=('Jetbrains Mono', 16), height=1)
        self.text.pack(expand=True, fill='both', side='left')
        scroll = ttk.Scrollbar(self, command=self.text.yview)
        scroll.pack(side=tk.LEFT, fill=tk.Y)
        self.text.config(yscrollcommand=scroll.set)
        self.id = 'gg'
        self.filename = None
        self.index = -1
        self.text_tab = ''

        self.code_lighting_theme = code_lighting_theme_dark
        if lighting:
            # self.text.tag_configure("KEYWORD", foreground='#ccccff')
            for tag_name in self.code_lighting_theme:
                self.text.tag_configure(tag_name, **self.code_lighting_theme[tag_name])
            self.text.bind("<KeyRelease>", self.syntax_lighting_update)
            self.text.config(exportselection=True)

    @exc_log
    def insert_text(self, s):
        state = self.text.cget('state')
        self.text.config(state='normal')
        self.text.insert('end', s)
        self.text.config(state=state)

    @exc_log
    def syntax_lighting_update(self, event=None):
        txt = self.text.get("1.0", 'end')
        setup_lexems = set()
        for tag in self.text.tag_names():
            self.text.tag_delete(tag)
        if self.lighting:
            # self.text.tag_configure("KEYWORD", foreground='#ccccff')
            for tag_name in self.code_lighting_theme:
                self.text.tag_configure(tag_name, **self.code_lighting_theme[tag_name])
        for syntax in imp_lexer.token_exprs228:
            if syntax[1] == None:
                continue
            indexes = [[m.start(), m.end()] for m in re.finditer(syntax[0], txt)]
            # print(syntax)
            for ind in indexes:

                supported = True
                for indi in setup_lexems:
                    ind2 = list(map(int, indi.split()))
                    if (ind2[0] < ind[0] < ind2[1]) or (ind2[0] < ind[1] < ind2[1]) or (
                            ind2[0] >= ind[0] and ind[1] >= ind2[1]):
                        supported = False
                        break
                # print(supported)
                if supported:
                    if syntax[1] == imp_lexer.RESERVED and syntax[0] in imp_lexer.KEYWORDS_TOKENS:
                        self.text.tag_add("KEYWORD2", f"1.0+{ind[0]}c", f"1.0+{ind[1]}c")

                    else:
                        self.text.tag_add(syntax[1], f"1.0+{ind[0]}c", f"1.0+{ind[1]}c")
                elif f"{ind[0]} {ind[1]}" in setup_lexems and syntax[0] in imp_lexer.KEYWORDS_TOKENS and syntax[
                    1] == imp_lexer.RESERVED:
                    self.text.tag_add("KEYWORD2", f"1.0+{ind[0]}c", f"1.0+{ind[1]}c")
                elif syntax[1] in [imp_lexer.ASM_CODE, imp_lexer.ASM_DATA, imp_lexer.ASM_INCLUDE]:
                    self.text.tag_add(syntax[1], f"1.0+{ind[0]}c", f"1.0+{ind[1]}c")
                    self.text.tag_raise(syntax[1])
                elif syntax[1] == imp_lexer.INCLUDE:
                    self.text.tag_add(syntax[1], f"1.0+{ind[0]}c", f"1.0+{ind[1]}c")
                    self.text.tag_raise(syntax[1])
                setup_lexems.add(f"{ind[0]} {ind[1]}")
        # self.text.tag_lower("KEYWORD2")


class App:
    @exc_log
    def __init__(self, app_settings, title="tk"):
        self.button_open = None
        self.button_save = None
        self.button_saveas = None
        self.localisation = dict()
        self.localisation["newfiletab"] = "+"
        self.localisation["toolbarfile"] = "Файл"
        self.localisation["toolbarbuild"] = "Сборка"
        self.localisation["toolbaredit"] = "Изменение"
        self.localisation["welcome"] = "Привет, Я Робин"
        self.localisation["welcometext"] = """
        Привет!
        Это простая IDE для Робина
        Она позволяет создавать, сохранять и изменять файлы.
        Она позволяет легко компилировать и запускать программы
        Надеюсь тебе зайдет!
        """
        self.code_styles_themes = {"dark std": CodeStyleObj(),
                                   "light std": CodeStyleObj(bg="#ddddaa", fg='#000033',
                                                             lighting_theme=code_lighting_theme_light),
                                   "dark sys": CodeStyleObj(font=("Courier New", 14, 'bold'))
                                   }
        self.toolbar_tab3 = None
        self.toolbar_notebook = None
        self.toolbar_tab1 = None
        self.toolbar_tab2 = None
        self.settings = app_settings
        self.main_window = ttkthemes.ThemedTk(app_settings["interface_theme"])
        self.main_window.title(title)
        self.style = ttkthemes.ThemedStyle()
        self.style.theme_use(app_settings["interface_theme"])
        self.theme_begin = app_settings["interface_theme"]
        self.codestyle_begin = app_settings["editor_theme"]
        print(self.style.theme_names())
        self.window = ttk.Frame(self.main_window)
        self.window.pack(expand=True, fill="both")
        self.init_toolbar()
        self.init_filespace()
        self.init_output()
        self.main_window.geometry("600x800")
        self.main_window.bind("<Control-s>", self.file_save)
        self.main_window.mainloop()


    @exc_log
    def init_toolbar(self):
        self.toolbar_frame = ttk.Frame(self.window)
        self.toolbar_frame.pack(fill='x')
        self.toolbar_notebook = ttk.Notebook(self.toolbar_frame)
        self.toolbar_notebook.pack(fill='x', side='left', expand=True)
        self.toolbar_notebook.enable_traversal()
        self.toolbar_tab1 = ttk.Frame(self.toolbar_notebook)
        self.toolbar_tab1.pack(fill='both', expand=True)
        self.toolbar_notebook.add(self.toolbar_tab1, text=self.localisation["toolbarfile"])
        self.button_save = ttk.Button(self.toolbar_tab1, text='Сохранить файл', command=self.file_save)
        self.button_save.grid(row=0, column=0, sticky="ns", pady=5, padx=5)
        self.button_open = ttk.Button(self.toolbar_tab1, text='Открыть файл', command=self.file_open)
        self.button_open.grid(row=0, column=1, sticky="ns", pady=5, padx=5)
        self.button_saveas = ttk.Button(self.toolbar_tab1, text='Сохранить Как файл', command=self.file_saveas)
        self.button_saveas.grid(row=0, column=3, sticky="ns", pady=5, padx=5)
        self.toolbar_tab2 = ttk.Frame(self.toolbar_notebook)
        self.toolbar_tab2.pack(fill='both', expand=True)
        self.toolbar_notebook.add(self.toolbar_tab2, text=self.localisation["toolbarbuild"])
        self.toolbar_entry_build_file = ttk.Entry(self.toolbar_tab2)
        self.toolbar_entry_build_file.place(relx=0, rely=0, relwidth=0.8)
        self.button_ask_build = ttk.Button(self.toolbar_tab2, text="Выбрать файл", command=self.set_build_file)
        self.button_ask_build.place(relx=1, rely=0, anchor="ne")
        self.button_build = ttk.Button(self.toolbar_tab2, text="Собрать", command=self.build_app)
        self.button_build.place(x = 0, y = 50)
        self.button_launch = ttk.Button(self.toolbar_tab2, text='Запустить', command=self.launch_app)
        self.button_launch.place(x =120, y = 50)
        self.toolbar_tab3 = ttk.Frame(self.toolbar_notebook)
        self.toolbar_tab3.pack(fill='both', expand=True)
        ttk.Label(self.toolbar_tab3, text="Из:").grid(row=0, column=0, pady=5, padx=5)
        self.edit_entry_replace_from = ttk.Entry(self.toolbar_tab3)
        self.edit_entry_replace_from.grid(row=0, column=1)
        ttk.Label(self.toolbar_tab3, text="В:").grid(row=1, column=0, pady=5, padx=5)
        self.edit_entry_replace_to = ttk.Entry(self.toolbar_tab3)
        self.edit_entry_replace_to.grid(row=1, column=1, pady=5, padx=5)
        ttk.Button(self.toolbar_tab3, text="Заменить", command=self.toolbar_replace_command).grid(row=0, column=2,
                                                                                                  rowspan=2,
                                                                                                  sticky="ns", pady=5, padx=5)
        ttk.Button(self.toolbar_tab3, text="Найти", command=self.search_in_file).grid(row=2, column=2, columnspan=1,
                                                                                      sticky="we", pady=5, padx=5)
        ttk.Button(self.toolbar_tab3, text="Убрать теги Найти", command=self.search_in_file_del_tag).grid(row=2,
                                                                                                          column=0,
                                                                                                          columnspan=2,
                                                                                                          sticky="we", pady=5, padx=5)
        self.toolbar_notebook.add(self.toolbar_tab3, text=self.localisation["toolbaredit"])
        self.toolbar_tab4_theme_style = ttk.Frame(self.toolbar_notebook)
        self.toolbar_notebook.add(self.toolbar_tab4_theme_style, text="Темы & Стили")
        try:
            themes = self.style.theme_names()
            themes.remove("breeze")
        except:
            pass
        self.toolbar_tab4_combobox_theme = ttk.Combobox(self.toolbar_tab4_theme_style, values=themes)
        self.toolbar_tab4_combobox_theme.grid(row=0, column=1, pady=5, padx=5)
        self.toolbar_tab4_combobox_theme.set(self.theme_begin)
        self.toolbar_tab4_combobox_theme.bind("<<ComboboxSelected>>", self.theme_use_combo_bind)
        ttk.Label(self.toolbar_tab4_theme_style, text="Тема интерфейса:").grid(row=0, column=0, pady=5, padx=5)
        self.toolbar_tab4_combobox_style = ttk.Combobox(self.toolbar_tab4_theme_style,
                                                        values=list(self.code_styles_themes.keys()))
        self.toolbar_tab4_combobox_style.grid(row=1, column=1, pady=5, padx=5)
        self.toolbar_tab4_combobox_style.set(self.settings["editor_theme"])
        self.toolbar_tab4_combobox_style.bind("<<ComboboxSelected>>", self.style_use_combo_bind)
        # self.toolbar_tab4_combobox_style.bind("<<ComboboxSelected>>", self.theme_use_combo_bind)
        ttk.Label(self.toolbar_tab4_theme_style, text="Тема редактора:").grid(row=1, column=0, pady=5, padx=5)
        self.toolbar_tab4_combobox_style_output = ttk.Combobox(self.toolbar_tab4_theme_style,
                                                               values=list(self.code_styles_themes.keys()))
        self.toolbar_tab4_combobox_style_output.grid(row=2, column=1, pady=5, padx=5)
        self.toolbar_tab4_combobox_style_output.set(self.settings["compiler_theme"])
        self.toolbar_tab4_combobox_style_output.bind("<<ComboboxSelected>>", self.style_out_use_combo_bind)
        # self.toolbar_tab4_combobox_style.bind("<<ComboboxSelected>>", self.theme_use_combo_bind)
        ttk.Label(self.toolbar_tab4_theme_style, text="Тема компилятора:").grid(row=2, column=0, pady=5, padx=5)

    @exc_log
    def init_filespace(self):
        self.new_file_n = 0
        self.files_space_frame = ttk.Frame(self.window)
        self.files_space_frame.pack(fill='both', expand=True)
        self.files_space_notebook = ttk.Notebook(self.files_space_frame)
        self.files_space_notebook.enable_traversal()
        self.files_space_notebook.pack(expand=True, fill='both')
        self.files_space_notebook.bind("<Button-3>", self.context_menu_file_space)

        self.files_tab = [FileField(self.files_space_notebook)]
        self.files_tab[0].pack(fill='both', expand=True)
        self.files_space_notebook.add(self.files_tab[0], text=self.localisation["newfiletab"])
        self.files_tab[0].insert_text("Пж в баг-репорт\n @FotonPC")
        self.new_file_tab_id = self.files_space_notebook.select()
        self.files_tab.append(FileField(self.files_space_notebook))
        self.files_tab[1].pack(fill='both', expand=True)

        self.files_space_notebook.add(self.files_tab[1], text=self.localisation["welcome"])
        self.files_tab[1].text.insert(1.0, self.localisation["welcometext"])
        self.files_tab[1].text.config(state='disabled')
        self.files_space_notebook.bind("<<NotebookTabChanged>>", self.select_files_tab)
        self.files_space_notebook.bind("<Button-3>", self.tab_contextmenu)

    @exc_log
    def init_output(self):
        self.output_frame = ttk.Frame(self.window)
        self.output_frame.pack(fill='x')
        self.output_notebook = ttk.Notebook(self.output_frame)
        self.output_notebook.enable_traversal()
        self.output_notebook.pack(expand=True, fill='both')
        self.output_tab1 = FileField(self.output_notebook, lighting=False )
        self.output_tab1.text.config(state='disabled')
        self.output_tab1.text.config(height=10)
        self.code_styles_themes[self.settings["compiler_theme"]].tkinter_set_tags(self.output_tab1)
        self.output_tab1.text.config(self.code_styles_themes[self.settings["compiler_theme"]].tkinter_get())
        self.output_tab1.pack(fill='both', expand=True)
        self.output_notebook.add(self.output_tab1, text="Вывод компилятора")

    @exc_log
    def toolbar_replace_command(self, event=None):
        id_c = self.files_space_notebook.select()
        for tab in self.files_tab:
            if tab.id == id_c:
                txt = tab.text.get("1.0", 'end')
                txt2 = txt.replace(self.edit_entry_replace_from.get(), self.edit_entry_replace_to.get())
                tab.text.delete('1.0', 'end')
                tab.insert_text(txt2)
                tab.syntax_lighting_update()
                break

    @exc_log
    def select_files_tab(self, event=None):
        tab_id = self.files_space_notebook.select()
        tab_name = self.files_space_notebook.tab(tab_id, "text")
        if tab_name == self.localisation["newfiletab"]:
            self.files_tab.append(FileField(self.files_space_notebook))
            self.files_tab[-1].pack(fill='both', expand=True)
            self.files_space_notebook.add(self.files_tab[-1], text=f"Новый {self.new_file_n} ")
            self.files_space_notebook.select(int(self.files_space_notebook.index('end')) - 1)
            self.files_tab[-1].id = self.files_space_notebook.select()
            self.files_tab[-1].index = self.files_space_notebook.index(self.files_tab[-1].id)
            self.files_tab[-1].text.config(**self.code_styles_themes[self.toolbar_tab4_combobox_style.get()].tkinter_get())
            self.code_styles_themes[self.toolbar_tab4_combobox_style.get()].tkinter_set_tags(self.files_tab[-1])
            self.new_file_n += 1

    @exc_log
    def file_open(self, event=None):
        fn = filedialog.askopenfilename()
        if not fn:
            return
        self.files_tab.append(FileField(self.files_space_notebook))
        self.files_tab[-1].pack(fill='both', expand=True)
        self.files_space_notebook.add(self.files_tab[-1], text=f"#[{self.new_file_n}] " + fn.split('/')[-1])
        self.files_space_notebook.select(int(self.files_space_notebook.index('end')) - 1)
        self.files_tab[-1].id = self.files_space_notebook.select()
        self.files_tab[-1].index = self.files_space_notebook.index(self.files_tab[-1].id)
        self.files_tab[-1].filename = fn
        self.files_tab[-1].text_tab = f"#[{self.new_file_n}] " + fn.split('/')[-1]
        self.files_tab[-1].text.config(**self.code_styles_themes[self.toolbar_tab4_combobox_style.get()].tkinter_get())
        self.code_styles_themes[self.toolbar_tab4_combobox_style.get()].tkinter_set_tags(self.files_tab[-1])

        try:
            with open(fn, encoding='utf-8') as file:
                self.files_tab[-1].insert_text(file.read())
        except UnicodeDecodeError:
            with open(fn) as file:
                self.files_tab[-1].insert_text(file.read())
        self.new_file_n += 1
        if self.toolbar_entry_build_file.get() == '':
            self.toolbar_entry_build_file.insert('end', fn)
        self.files_tab[-1].syntax_lighting_update()

    @exc_log
    def file_save(self, event=None):
        tab_id = self.files_space_notebook.select()
        for tab in self.files_tab:
            if tab.id == tab_id:
                if tab.filename is not None:
                    with open(tab.filename, 'w+', encoding='utf-8') as file:
                        file.write(tab.text.get(1.0, 'end'))
                else:
                    fn = filedialog.asksaveasfilename()
                    with open(fn, 'w+', encoding='utf-8') as file:
                        file.write(tab.text.get(1.0, 'end'))
                        tab.filename = fn
                        fn2 = fn.split('/')[-1]
                        self.files_space_notebook.tab(tab.id, text=f"#[{self.new_file_n}] {fn2}")
                break

    @exc_log
    def file_saveas(self, event=None):
        tab_id = self.files_space_notebook.select()
        for tab in self.files_tab:
            if tab.id == tab_id:
                try:
                    fn = filedialog.asksaveasfilename()
                    with open(fn, 'w+', encoding='utf-8') as file:
                        file.write(tab.text.get(1.0, 'end'))
                        tab.filename = fn
                except:
                    pass
                break

    @exc_log
    def set_build_file(self, event=None):
        self.toolbar_entry_build_file.delete('0', 'end')
        self.toolbar_entry_build_file.insert('end', filedialog.askopenfilename())

    @exc_log
    def build_app(self):
        filename = self.toolbar_entry_build_file.get()
        robin_directory = os.getcwd()
        file_directory = '\\'.join(filename.split('\\')[:-1])
        if file_directory == '':
            file_directory = robin_directory
        text = open(filename, encoding='utf-8').read()
        self.output_tab1.insert_text('[Программа загружена]\n')
        tokens = imp_lexer.imp_lex(text)
        self.output_tab1.insert_text('[Программа лексирована]\n')
        os.chdir(file_directory)
        parse_result = parse.Statement(tokens=tokens)
        self.output_tab1.insert_text('[Программа распарсена]\n')
        robin_assembler = ro_asm_compiler.make_asm(parse_result)
        self.output_tab1.insert_text('[Программа собрана в MASM]\n')
        self.output_tab1.insert_text(robin_assembler + '\n')
        with open(filename.split('.')[-2].split('\\')[-1] + '.masm', 'w+') as f:
            f.write(robin_assembler)
        os.chdir(robin_directory)
        print(robin_directory)
        make_exe.main(filename.split('.')[-2].split('\\')[-1] + '.masm')

    @exc_log
    def launch_app(self):
        th = threading.Thread(target=self._launch_app)
        th.start()

    @exc_log
    def _launch_app(self):
        os.system(self.toolbar_entry_build_file.get()[
                  :self.toolbar_entry_build_file.get().rindex('.'):] + '.exe && getchar_pro.exe')

    @exc_log
    def context_menu_file_space(self, event=None, x=0, y=0, id=1):
        top = tk.Toplevel(self.main_window)
        top.geometry(f"+{x}+{y}")
        top.overrideredirect(True)
        frm = ttk.Frame(top)
        frm.pack(expand=True, fill="both")

        def close_tab(event=None, i=id):
            self.main_window.update()
            for tab in self.files_tab:
                if tab.text_tab == self.files_space_notebook.tab(i, 'text'):
                    if tkinter.messagebox.askyesno("Сохранение?", message='Сохранить файл'):
                        if tab.filename is not None:
                            with open(tab.filename, 'w+', encoding='utf-8') as file:
                                file.write(tab.text.get(1.0, 'end'))
                        else:
                            try:
                                fn = filedialog.asksaveasfilename()
                                with open(fn, 'w+', encoding='utf-8') as file:
                                    file.write(tab.text.get(1.0, 'end'))
                                    tab.filename = fn
                            except:
                                pass
                    self.files_tab.remove(tab)
                    break
            self.files_space_notebook.forget(i)
            top.destroy()

        ttk.Button(frm, text="Закрыть", command=close_tab).pack()
        top.resizable(False, False)
        top.mainloop()

    @exc_log
    def tab_contextmenu(self, event=None):
        if self.files_space_notebook.identify(event.x, event.y) == 'label':
            index = self.files_space_notebook.index(f'@{event.x},{event.y}')
            print(index)
            if index >= 2:
                self.context_menu_file_space(x=event.x_root, y=event.y_root, id=index)

    @exc_log
    def theme_use_combo_bind(self, event=None):
        self.style.theme_use(self.toolbar_tab4_combobox_theme.get())

    @exc_log
    def style_use_combo_bind(self, event=None):
        st = self.code_styles_themes[self.toolbar_tab4_combobox_style.get()]
        for tab in self.files_tab:
            tab.text.config(**st.tkinter_get())
            self.code_styles_themes[self.toolbar_tab4_combobox_style.get()].tkinter_set_tags(tab)
        self.settings["editor_theme"] = self.toolbar_tab4_combobox_style.get()

    @exc_log
    def style_out_use_combo_bind(self, event=None):
        st = self.code_styles_themes[self.toolbar_tab4_combobox_style_output.get()]
        self.output_tab1.text.config(**st.tkinter_get())
        self.settings["compiler_theme"] = self.toolbar_tab4_combobox_style_output.get()

    @exc_log
    def search_in_file(self, event=None):
        tab_id = self.files_space_notebook.select()
        for tab in self.files_tab:
            if tab.id == tab_id:
                try:
                    txt = tab.text.get('1.0', "end")
                    finds = [[m.start(), m.end()] for m in
                             re.finditer(simpledialog.askstring("Найти", "Введите запрос для поиска"), txt)]
                    messagebox.showinfo(title="Найдено", message=f"Найдено {len(finds)} вхождений")
                    tab.text.tag_configure("FINDS_TAG", background="red")
                    for f in finds:
                        tab.text.tag_add("FINDS_TAG", f"1.0+{f[0]}c", f"1.0+{f[1]}c")
                except:
                    pass
                break

    @exc_log
    def search_in_file_del_tag(self, event=None):
        tab_id = self.files_space_notebook.select()
        for tab in self.files_tab:
            if tab.id == tab_id:
                try:
                    tab.text.tag_delete("FINDS_TAG")
                except:
                    pass
                break


if __name__ == "__main__":
    try:
        try:
            with open(settings_json_path) as settings_file:
                settings = json.load(settings_file)
        except Exception as error:
            settings = template_settings
            print(error)
        App(settings, title="Robin 2 IDE")
    except Exception as err:
        w = tk.Tk()
        exc_type, exc_value, exc_traceback = sys.exc_info()
        lines = traceback.format_exception(exc_type, exc_value, exc_traceback)
        x = '\n'.join(lines)
        tk.Label(w, text=f"""
        {err}
        {lines}
        main exception
        """).pack()
        w.mainloop()
