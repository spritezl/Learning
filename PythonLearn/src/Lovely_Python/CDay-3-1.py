# -*- coding: utf-8 -*-
import os
def cdWalker(cdrom, cdcfile):
    export=[]
    for root, dirs, files in os.walk(cdrom):
        export.append('\n%s %s %s'%(root,dirs,files))
    open(cdcfile,'w').write(''.join(export))

cdWalker('E:\Study\Dev\Python', 'mycdc.cdc')    