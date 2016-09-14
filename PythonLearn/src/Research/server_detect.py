# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 14:29:16 2016

Check if a server is active or not through a PING command
@author: fzhang
"""


def check_server(serverHost):
    import os
    NOT_ACTIVE_PATTERN = 'Destination host unreachable'
    output = os.popen('ping -n 1 %s' % serverHost).read()
    if NOT_ACTIVE_PATTERN in output:
        return False
    else:
        return True

if __name__ == '__main__':
    print(check_server('10.125.2.236'))
