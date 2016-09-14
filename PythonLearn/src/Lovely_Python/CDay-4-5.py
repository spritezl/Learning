# -*- coding: utf-8 -*-
import os
export=[]
for root, dirs, files in os.walk('E:\Study\Dev\Python'):
    export.append('\n%s %s %s'%(root,dirs,files))
open('mycdc2.cdc','w').write(''.join(export))