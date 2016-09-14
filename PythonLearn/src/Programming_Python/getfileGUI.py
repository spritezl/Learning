'''
Created on Feb 19, 2016

@author: fzhang

launch getfile client with a reusable GUI form class;
os.chdir to target local dir if input(getfile stores in cwd);
to do:use threads, show download status and getfile prints;
'''


from Programming_Python.form import Form
from tkinter import Tk, mainloop
from tkinter.messagebox import showinfo
import Programming_Python.getfile as getfile
import os


class GetFileForm(Form):
    def __init__(self, oneshot=False):
        root = Tk()
        root.title('getfileGUI')
        labels = ['Server Name', 'Port', 'File Name', 'Local Dir?']
        Form.__init__(self, labels, root)
        self.oneshot = oneshot

    def onSubmit(self):
        Form.onSubmit(self)
        localdir = self.content['Local Dir?'].get()
        portnumber = self.content['Port'].get()
        servername = self.content['Server Name'].get()
        filename = self.content['File Name'].get()
        if localdir:
            os.chdir(localdir)
        portnumber = int(portnumber)
        getfile.client(servername, portnumber, filename)
        showinfo('getfileGui', 'Download Complete')
        if self.oneshot:
            Tk().quit()

if __name__ == '__main__':
    GetFileForm()
    mainloop()
