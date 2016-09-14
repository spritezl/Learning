# -*- coding: utf-8 -*-
import os
for root, dirs, files in os.walk('E:\Study\Dev\Python'):
    open('mycdc','a').write('%s %s %s'%(root,dirs,files))