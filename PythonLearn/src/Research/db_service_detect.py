# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 14:29:16 2016

Check how many oracle services a server is providing
Check how many oracle services are opened or closed
@author: fzhang
"""


def get_db_services(serverHost, oracleUser, oracleUserPassword):
    import paramiko
    import re
    serverPORT = 22
    db_services = []
    s = paramiko.SSHClient()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        s.connect(serverHost, serverPORT, oracleUser, oracleUserPassword)
        _, stdout, _ = s.exec_command('source ./.bash_profile;lsnrctl status')
        for line in stdout.readlines():
            m = re.match(r'Service (?P<quote>["])(?P<service>.*)(?P=quote)',
                         line)
            if (m is not None and
                not m.group('service').endswith('XDB') and
                    not m.group('service').startswith('EXTPROC')):
                    db_services.append(m.group('service'))
    except:
        pass
    finally:
        s.close()
        return db_services


def check_db_service_status(serverHost, db_services):
    import cx_Oracle
    ORA_SYSTEM_USER = 'system'
    ORA_SYSTEM_USER_PWD = 'manager'
    db_services_status = {}
    for db_service in db_services:
        print(db_service)
        try:
            conn = cx_Oracle.connect('%s/%s@%s/%s' % (ORA_SYSTEM_USER,
                                                      ORA_SYSTEM_USER_PWD,
                                                      serverHost,
                                                      db_service))
            db_services_status[db_service] = 'OPEN'
            conn.close()
        except:
            db_services_status[db_service] = 'CLOSED'
    return db_services_status

if __name__ == '__main__':
    db_services = get_db_services('10.125.2.236', 'oracle', 'oracle')
    print(check_db_service_status('10.125.2.236', db_services))
