'''
Created on Feb 18, 2016

@author: fzhang

###############################################################################
Tools for connecting standard streams of non-GUI programs to sockets that
a GUI (or other) program can use to interact with the non-GUI program.
###############################################################################
'''

from socket import *  # @UnusedWildImport
port = 50008        # pass in different port if multiple dialogs on Machine
host = 'localhost'  # pass in different host to connect to remote listeners


def initListenerSocket(port=port):
    """
    initialize connected socket for callers that listen in server Mode
    """
    sock = socket(AF_INET, SOCK_STREAM)
    sock.bind('', port)
    sock.listen(5)
    conn, _ = sock.accept()
    return conn


def redirectOut(port=port, host=host):
    """
    connect caller's standard output stream to a socket for GUI to listen
    start caller after listener started, else connect fails before accept
    """
    sock = socket(AF_INET, SOCK_STREAM)
    sock.connect((host, port))
    file = sock.makefile('w')
    sys.stdout = file
    return sock


def redirectIn(port=port, host=host):
    """
    connect caller's standard input stream to a socket for GUI to provide
    """
    sock = socket(AF_INET, SOCK_STREAM)
    sock.connect((host, port))
    file = sock.makefile('r')
    sys.stdin = file
    return sock


def redirectBothAsClient(port=port, host=host):
    """
    connect caller's standard input and output stream to same socket
    in this mode, caller is client to a server: send msg, receiver reply
    """
    sock = socket(AF_INET, SOCK_STREAM)
    sock.connect((host, port))
    ofile = sock.makefile('w')
    ifile = sock.makefile('r')
    sys.stdout = ofile
    sys.stdin = ifile
    return sock


def redirectBothAsServer(port=port, host=host):
    """
    connect caller's standard input and output stream to sake socket
    in this mode, caller is server to client,receives msg, send reply
    """
    sock = socket(AF_INET, SOCK_STREAM)
    sock.bind((host, port))
    sock.listen(5)
    conn, _ = sock.accept()
    ofile = conn.makefile('w')
    ifile = conn.makefile('r')
    sys.stdout = ofile
    sys.stdin = ifile
    return sock
