'''
Created on Apr 28, 2016

@author: fzhang
'''

import codecs
import chardet
BLOCKSIZE = 1048576  # or some other, desired size in bytes

with open('e:\download\door.txt', "rb") as sourceFile:
    print(chardet.detect(sourceFile.read()))

with open('e:\download\door.txt', "rb") as sourceFile:
    # print(chardet.detect(sourceFile.read().encode('IBM855')))
    with open('e:\download\door1.txt', "wb") as targetFile:
        while True:
            contents = sourceFile.read(BLOCKSIZE).decode('GB2312')
            print(contents)
            if not contents:
                break
            targetFile.write(contents.encode('utf8'))
