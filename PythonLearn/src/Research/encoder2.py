'''
Created on Apr 28, 2016

@author: fzhang
'''


def tryEncode(s, encoding="utf-8"):
    try:
        print(s.encode(encoding))
    except UnicodeEncodeError as err:
        print(err)

s = "$"           # UTF-8 String
tryEncode(s)          # Ĭ���� UTF-8 ���б���
tryEncode(s, "ascii")  # ������ ASCII ���б���

s = "��"          # UTF-8 String
tryEncode(s)          # Ĭ���� UTF-8 ���б���
tryEncode(s, "ascii")  # ������ ASCII ���б���
tryEncode(s, "GB2312")  # ������ GB2312 ���б���
