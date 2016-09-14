#!/usr/local/bin/python
'''
Created on Feb 19, 2016

@author: fzhang

A Python script to download and play a media file by FTP.
Uses ftplib, the ftp protocol handler which uses sockets.
Ftp runs on 2 sockets(one for data, one for control--ports
20 and 21) and imposes message text formats, but Python's
ftplib module hides most of this protocol's details.
Change for your site/file.
'''


import sys
from getpass import getpass     # hidden password input
from ftplib import FTP          # socket-based FTP tools

nonpassive = False              # force active mode FTP for server?
filename = 'monkeys.jpg'        # file to downloaded
dirname = '.'                   # remote directory to fetch from
sitename = 'ftp.rmi.net'        # FTP site to connect
userinfo = ('lutz', getpass('Pswd'))    # use () for anonymous
if len(sys.argv) > 1:
    filename = sys.argv[1]

print('Connecting...')
connection = FTP(sitename)
connection.login(*userinfo)
connection.cwd(dirname)
if nonpassive:
    connection.set_pasv(False)

print('Downloading...')
localfile = open(filename, 'wb')
connection.retrbinary('RETR '+filename, localfile.write, 1024)
connection.quit()
localfile.close()
