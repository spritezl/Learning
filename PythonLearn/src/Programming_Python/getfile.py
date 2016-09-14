'''
Created on Feb 19, 2016

@author: fzhang
#############################################################################
implement client and sever-side logic to transfer an arbitrary file from
server to client over a socket; uses a simple control-info protocol rather
than separate sockets for control and data(as in ftp), dispatches each
client request to a handler thread, and loops to transfer the entire file
by blocks; see ftplib examples for a higher-level transport scheme;
#############################################################################
'''


import time
from socket import *  # @UnusedWildImport
import _thread as thread

blksz = 1024
defaultHost = 'localhost'
defaultPort = 50001

helptext = """
Usage...
server=> getfile.py -mode server [-port nnn] [-host hhh|localhost]
client=> getfile.py [-mode client] -file fff [-port nnn] [-host hhh|localhost]
"""


def now():
    return time.asctime()


def parseCommandLine():
    resultdict = {}
    args = sys.argv[1:]  # put in dictionary for easy lookup
    while len(args) >= 2:  # skip program name at front of args
        resultdict[args[0]] = args[1]  # example; dict['-mode'] = 'server'
        args = args[2:]
    return resultdict


def client(host, port, filename):
    sock = socket(AF_INET, SOCK_STREAM)
    sock.connect((host, port))
    sock.send((filename + '\n').encode())  # send remote name with dir:bytes
    dropdir = os.path.split(filename)[1]  # filename at end of dir path
    file = open(dropdir, 'wb')  # create local file in cwd
    while True:
        data = sock.recv(blksz)  # get up to 1K at a time
        if not data:  # till closed on server side
            break
        file.write(data)  # store data in local file
        sock.close()
        file.close()
        print('Client got', filename, 'at', now())


def serverThread(clientsock):
    sockfile = clientsock.makefile('r')  # wrap socket in dup file obj
    filename = sockfile.readline()[:-1]  # get filename up to end-line
    try:
        file = open(filename, 'rb')
        while True:
            bytes = file.read(blksz)  # @ReservedAssignment
            if not bytes:
                break
            sent = clientsock.send(bytes)
            assert sent == len(bytes)
    except:
        print('Error downloading file on server:', filename)
    clientsock.close()


def server(host, port):
    serversock = socket(AF_INET, SOCK_STREAM)
    serversock.bind((host, port))
    serversock.listen(5)
    while True:
        clientsock, clientaddr = serversock.accept()
        print('Server connected by', clientaddr, 'at', now())
        thread.start_new_thread(serverThread, (clientsock,))


def main(args):
    host = args.get('-host', defaultHost)
    port = int(args.get('-port', defaultPort))
    if args.get('-mode') == 'server':
        if host == 'localhost':
            host = ''
        server(host, port)
    elif args.get('-file'):
        client(host, port, args['-file'])
    else:
        print(helptext)


if __name__ == '__main__':
    args = parseCommandLine()
    main(args)
