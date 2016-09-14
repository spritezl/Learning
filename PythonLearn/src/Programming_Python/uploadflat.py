#!/bin/env python
'''
Created on Feb 23, 2016

@author: fzhang

##############################################################################
use FTP to upload all files from one local dir to a remote site/directory;
e.g., run me to copy a web/FTP site's files from your PC to your ISP;
assumes a flat directory upload: uploadall.py does nested directories.
see downloadflat.py comments for more notes: this script is symmetric.
##############################################################################
'''

import os
import sys
import ftplib
from getpass import getpass
from mimetypes import guess_type
from Programming_Python.downloadflat import localfile

nonpassive = False
remotesite = 'learning-python.com'
remotedir = 'books'
remoteuser = 'lutz'
remotepass = getpass('Password for %s on %s:' % (remoteuser, remotesite))
localdir = (len(sys.argv) > 1 and sys.argv[1]) or '.'
cleanall = input('Clean remote directory first?')[:1] in ['y', 'Y']

print('connecting...')
connection = ftplib.FTP(remotesite)
connection.login(remoteuser, remotepass)
connection.cwd(remotedir)
if nonpassive:
    connection.set_pasv(False)

if cleanall:
    for remotename in connection.nlst():
        try:
            print('deleting remote', remotename)
            connection.delete(remotename)
        except:
            print('can not delete remote', remotename)

count = 0
localfiles = os.listdir(localdir)

for localname in localfiles:
    mimetype, encoding = guess_type(localname)
    mimetype = mimetype or '?/?'
    maintype = mimetype.split('/')[0]

    localpath = os.path.join(localdir, localname)
    print('uploading', localpath, 'to', localname, end=' ')
    print('as', maintype, encoding or '')

    if maintype == 'text' and encoding is None:
        localfile = open(localpath, 'rb')
        connection.storlines('STOR '+localname, localfile)
    else:
        localfile = open(localpath, 'rb')
        connection.storbinary('STOR '+localname, localfile)

    localfile.close()
    count += 1

connection.quit()
print('Done:', count, 'files uploaded.')
