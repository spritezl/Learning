# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 14:29:16 2016

Check all kinds of services a Host providing by scan its specific ports
@author: fzhang
"""


def check_service_by_port(serverHost, serverPort):
    import socket
    # create an INET, STREAMing socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.connect((serverHost, serverPort))
    except:
        status = False
    else:
        status = True
    finally:
        s.close()
        return status


def check_db_service(serverHost):
    return check_service_by_port(serverHost, 1521)


def check_apache_service(serverHost):
    return check_service_by_port(serverHost, 80)


def check_tomcat_service(serverHost):
    return check_service_by_port(serverHost, 8009)

if __name__ == '__main__':
    print(check_db_service('10.125.2.236'))
