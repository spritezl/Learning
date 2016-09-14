# -*- coding: utf-8 -*-
"""
Created on Mon Feb  1 11:39:07 2016

@author: fzhang
"""

from datetime import datetime, timedelta
from Perf.perf_analyse import cpu_chart, memory_chart, network_chart,\
 queue_chart, io_chart
import os

# parameter setting
input_starttime = "13:30:21"
input_endtime = "13:48:47"
cpu_file = r"load20160118_cpu22.txt"
io_file = r"load20160118_disk22.txt"
memory_file = r"load20160118_memory22.txt"
network_file = r"load20160118_network22.txt"
queue_file = r"load20160118_queue22.txt"

sourcepath = r"D:\Project\Allocation\Load\20160118"
targetpath = r"D:\Project\Allocation\Load\20160118\Result\DT_SaveClose"

starttime = datetime.strftime(datetime.strptime(input_starttime,
                                                '%H:%M:%S') -
                              timedelta(seconds=10, minutes=2), '%H:%M:%S')
endtime = datetime.strftime(datetime.strptime(input_endtime,
                                              '%H:%M:%S') -
                            timedelta(seconds=10, minutes=2), '%H:%M:%S')

tomcat_servers = ['180', '181', '182', '189']
for server in tomcat_servers:
    server_type = "Tomcat"
    category = server_type + server

    cpu_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + cpu_file
    cpu_targetfile = r"cpu" + server + r".png"
    cpu_chart(category, cpu_sourcefile, starttime, endtime,
              targetpath, cpu_targetfile)

    memory_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + memory_file
    memory_targetfile = r"memory" + server + r".png"
    memory_chart(category, memory_sourcefile, starttime, endtime,
                 targetpath, memory_targetfile)

    network_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + network_file
    network_targetfile = r"network" + server + r".png"
    network_chart(category, network_sourcefile, starttime, endtime,
                  targetpath, network_targetfile)

    queue_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + queue_file
    queue_targetfile = r"queue" + server + r".png"
    queue_chart(category, queue_sourcefile, starttime, endtime,
                targetpath, queue_targetfile)


starttime = datetime.strftime(datetime.strptime(input_starttime,
                                                '%H:%M:%S') +
                              timedelta(minutes=6), '%H:%M:%S')
endtime = datetime.strftime(datetime.strptime(input_endtime,
                                              '%H:%M:%S') +
                            timedelta(minutes=6), '%H:%M:%S')
db_servers = ['236']
for server in db_servers:
    server_type = "DB"
    category = server_type + server

    cpu_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + cpu_file
    cpu_targetfile = r"cpu" + server + r".png"
    cpu_chart(category, cpu_sourcefile, starttime, endtime,
              targetpath, cpu_targetfile)

    io_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + io_file
    io_targetfile = r"io" + server + r".png"
    io_chart(category, io_sourcefile, starttime, endtime,
             targetpath, io_targetfile)

    memory_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + memory_file
    memory_targetfile = r"memory" + server + r".png"
    memory_chart(category, memory_sourcefile, starttime, endtime,
                 targetpath, memory_targetfile)

    network_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + network_file
    network_targetfile = r"network" + server + r".png"
    network_chart(category, network_sourcefile, starttime, endtime,
                  targetpath, network_targetfile)

    queue_sourcefile = sourcepath + os.sep + server_type + \
        os.sep + server + os.sep + queue_file
    queue_targetfile = r"queue" + server + r".png"
    queue_chart(category, queue_sourcefile, starttime, endtime,
                targetpath, queue_targetfile)
