'''
Created on Feb 19, 2016

@author: fzhang
launch get file script client from simple tkinter GUI;
could also use os.fork+exec, os.spawnv(see Launcher);
windows:replace 'python' with 'start' if not on path;
'''


import os
from tkinter import *  # @UnusedWildImport
from tkinter.messagebox import showinfo


def onReturnKey():
    cmdline = ('python getfile.py -mode client -file %s -port %s -host %s' %
               (content['File'].get(),
                content['Port'].get(),
                content['Server'].get()))
    os.system(cmdline)
    showinfo('getfileGui_1', 'Download complete')

box = Tk()
labels = ['Server', 'Port', 'File']
content = {}
for label in labels:
    row = Frame(box)
    row.pack(fill=X)
    Label(row, text=label, width=6).pack(side=LEFT)
    entry = Entry(row)
    entry.pack(side=RIGHT, expand=YES, fill=X)
    content[label] = entry


box.title('getfileGui_1')
box.bind('<Return>', (lambda event: onReturnKey()))
mainloop()
