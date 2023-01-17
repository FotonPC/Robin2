import tkinter as tk
from tkinter import ttk

win = tk.Tk()
nb = ttk.Notebook(win)
fr = ttk.Frame(nb)
fr.pack(expand=True, fill='both')
nb.add(fr, text="Some")
nb.pack(expand=True, fill='both')
nb.bind("<Button>", lambda e: print("ez gg"))
win.mainloop()