#!/usr/local/bin/python
'''
Created on Feb 19, 2016

@author: fzhang

A Python script to download a file by FTP by its URL string; use higher-level
urllib instead of ftplib to fetch file; urllib supports FTP, HTTP, client-side
HTTPS, and local files, and handles proxies, redirects, cookies, and more;
urllib also allows downloads of html pages, images, text, etc.; see also
Python html/xml parsers for web pages fetched by urllib in Chapter 19;
'''

import getpass
from urllib.request import urlopen  # socket-based web tools

filename = 'monkeys.jpg'
password = getpass.getpass('Pswd?')

remoteaddr = 'ftp://lutz:%s@ftp.rmi.net/%s' % (password, filename)

# this works too:
# urllib.request.urlretrieve(remoteaddr, filename)

remotefile = urlopen(remoteaddr)
localfile = open(filename, 'wb')
localfile.write(remotefile.read())
localfile.close()
remotefile.close()
