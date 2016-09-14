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
tryEncode(s)          # 默认用 UTF-8 进行编码
tryEncode(s, "ascii")  # 尝试用 ASCII 进行编码

s = "雨"          # UTF-8 String
tryEncode(s)          # 默认用 UTF-8 进行编码
tryEncode(s, "ascii")  # 尝试用 ASCII 进行编码
tryEncode(s, "GB2312")  # 尝试用 GB2312 进行编码
