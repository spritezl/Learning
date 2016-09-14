#!/usr/local/bin/python
'''
Created on Feb 19, 2016

@author: fzhang

Fetch an arbitrary file by FTP. Anonymous FTP unless you pass a
user=(name, pswd) tuple. Self-test FTPs a test file and site.
'''

from ftplib import FTP
from os.path import exists


def getfile(file, site, remotedir, user=(), *, verbose=True, refetch=False):
    """
    fetch a file by ftp from a site/directory
    anonymous or real login, binary transfer
    """
    if exists(file) and not refetch:
        if verbose:
            print(file, 'already fetched')
    else:
        if verbose:
            print('Downloading', file)
        local = open(file, 'wb')
        try:
            remote = FTP(site)
            remote.login(*user)
            remote.cwd(remotedir)
            remote.retrbinary('RETR '+file, local.write(), 1024)
            remote.quite()
        finally:
            local.close()
        if verbose:
            print('Download done.')

if __name__ == '__main__':
    from getpass import getpass
    file = 'monkeys.jpg'
    remotedir = '.'
    site = 'ftp.rmi.net'
    user = ('lutz', getpass('Pswd?'))
    getfile(file, site, remotedir, user)
