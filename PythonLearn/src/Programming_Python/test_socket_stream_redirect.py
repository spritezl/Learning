'''
Created on Feb 18, 2016

@author: fzhang
###############################################################################
test the socket_stream_redirection.py modes
###############################################################################
'''
###############################################################################
# redirected client output
###############################################################################


def server1():
    import os
    from Programming_Python.socket_stream_redirect import initListenerSocket
    mypid = os.getpid()
    conn = initListenerSocket()
    file = conn.makefile('r')
    for _ in range(3):
        data = file.readline().rstrip()
        print('server %s got [%s]' % (mypid, data))


def client1():
    import sys
    import os
    from Programming_Python.socket_stream_redirect import redirectOut
    mypid = os.getpid()
    redirectOut()
    for i in range(3):
        print('client %s:%s' % (mypid, i))
        sys.stdout.flush()


###############################################################################
# redirected client input
###############################################################################

def server2():
    import os
    from Programming_Python.socket_stream_redirect import initListenerSocket
    mypid = os.getpid()
    conn = initListenerSocket()
    for i in range(3):
        conn.send(('server %s:%s\n' % (mypid, i)).encode())


def client2():
    import os
    from Programming_Python.socket_stream_redirect import redirectIn
    mypid = os.getpid()
    redirectIn()
    for _ in range(3):
        data = input()
        print('client %s got [%s]' % (mypid, data))


###############################################################################
# redirect client input + output, client is socket client
###############################################################################

def server3():
    import os
    from Programming_Python.socket_stream_redirect import initListenerSocket
    mypid = os.getpid()
    conn = initListenerSocket()
    file = conn.makefile('r')
    for _ in range(3):
        data = file.readline().rstrip()
        conn.send(('server %s got [%s]\n' % (mypid, data)).encode())


def client3():
    import sys
    import os
    from Programming_Python.socket_stream_redirect import redirectBothAsClient
    mypid = os.getpid()
    redirectBothAsClient()
    for i in range(3):
        print('client %s:%s' % (mypid, i))
        data = input()
        sys.stderr.write('client %s got [%s]' % (mypid, data))


###############################################################################
# redirect client input + output, client is socket server
###############################################################################
def server4():
    import os
    from Programming_Python.socket_stream_redirect import initListenerSocket
    mypid = os.getpid()
    conn = initListenerSocket()
    file = conn.makefile('r')
    for i in range(3):
        file.send(('server %s: %s\n' % (mypid, i)).encode())  # send to input()
        data = file.readline().rstrip()  # recv from print()
        print('server %s got [%s]' % (mypid, data))  # result to terminal


def client4():
    import sys
    import os
    from Programming_Python.socket_stream_redirect import redirectBothAsServer
    mypid = os.getpid()
    redirectBothAsServer()  # I'm actually the socket server in this mode
    for _ in range(3):
        data = input()  # input from socket: flushes!
        print('client %s got [%s]' % (mypid, data))  # print to socket
        sys.stdout.flush()  # else last buffered till exit!


###############################################################################
# redirect client input + output, client is socket client, server xfers first
###############################################################################
def server5():
    import os
    from Programming_Python.socket_stream_redirect import initListenerSocket
    mypid = os.getpid()  # test 4, but server accepts
    conn = initListenerSocket()  # wait for client connect
    file = conn.makefile('r')  # send input(), recv print()
    for i in range(3):
        conn.send(('server %s: %s\n' % (mypid, i)).encode())
        data = file.readline().rstrip()
        print('server %s got [%s]' % (mypid, data))


def client5():
    import sys
    import os
    from Programming_Python.socket_stream_redirect import redirectBothAsClient
    mypid = os.getpid()
    redirectBothAsClient()  # I'm the socket client in this mode
    for _ in range(3):
        data = input()  # input from socket: flushes!
        print('client %s got [%s]' % (mypid, data))  # print to socket
        sys.stdout.flush()  # else last buffered till exit!


###############################################################################
# test by number on command-line
###############################################################################
if __name__ == '__main__':
    import sys
    from multiprocessing import process
    server = eval('server' + sys.argv[1])
    client = eval('client' + sys.argv[1])  # client in this process
    process(target=server).start()  # server in new process
    client()  # reset streams in client
    # import time; time.sleep(5) # test effect of exit flush
