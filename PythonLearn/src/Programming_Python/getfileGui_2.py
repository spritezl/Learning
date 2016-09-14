'''
Created on Feb 19, 2016

@author: fzhang
same, but with grids and import + call, not packs and cmdline;
direct function calls are usually faster than running files;
'''

import Programming_Python.getfile as getfile
from tkinter import *  # @UnusedWildImport
from tkinter.messagebox import showinfo


def onSubmit():
    getfile.client(content['Server'].get(),
                   int(content['Port'].get()),
                   content['File'].get())
    showinfo('getfileGui_2', 'Download complete')


box = Tk()
labels = ['Server', 'Port', 'File']
rownum = 0
content = {}
for label in labels:
    Label(box, text=label).grid(column=0, row=rownum)
    entry = Entry(box)
    entry.grid(column=1, row=rownum, sticky=E+W)
    content[label] = entry
    rownum += 1

box.columnconfigure(0, weight=0)  # make expandable
box.columnconfigure(1, weight=1)
Button(text='Submit', command=onSubmit).grid(row=rownum,
                                             column=0,
                                             columnspan=2)
box.title('getfilegui_2')
box.bind('<Return>', (lambda event: onSubmit()))
mainloop()
