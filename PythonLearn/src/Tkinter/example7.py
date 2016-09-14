'''
Created on Apr 20, 2016

@author: fzhang
'''
from tkinter import *  # @UnusedWildImport
from tkinter import ttk  # @Reimport

root = Tk()
tree = ttk.Treeview(root)
id = tree.insert('', 'end', 'Dims', text='Dims')  # @ReservedAssignment
tree.insert(id, 'end', text='style')
tree.insert(id, 'end', text='date')
tree.insert(id, 'end', text='loc')
tree.grid(column=0, row=0, sticky='nswe')
root.grid_columnconfigure(0, weight=1)
root.grid_rowconfigure(0, weight=1)

root.mainloop()
