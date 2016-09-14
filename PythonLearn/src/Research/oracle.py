'''
Created on Mar 31, 2016

@author: fzhang
'''


import cx_Oracle
import csv

conn = cx_Oracle.connect('appuser/sol@10.125.2.236/bsapp')
cur1 = conn.cursor()
sql = 'SELECT * FROM users'
cur1.execute(sql)
csv.register_dialect('excel', delimiter=',', quoting=csv.QUOTE_MINIMAL)
fileHeader = open('test.csv', 'w')
filename = csv.writer(fileHeader, dialect='excel')

for row in cur1:
    filename.writerow(row)
fileHeader.close()
cur1.close()
conn.close()
