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
input_starttime = "14:40:00"
input_endtime = "15:05:41"
cpu_file = r"load20170806_cpu.txt"
io_file = r"load20170806_disk.txt"
memory_file = r"load20170806_memory.txt"
network_file = r"load20170806_network.txt"
queue_file = r"load20170806_queue.txt"

sourcepath = r"D:\Project\Allocation\Load\20170806"
targetpath = r"D:\Project\Allocation\Load\20170806\Result"

# starttime = datetime.strftime(datetime.strptime(input_starttime,
#                                                 '%H:%M:%S') -
#                               timedelta(seconds=10, minutes=2), '%H:%M:%S')
# endtime = datetime.strftime(datetime.strptime(input_endtime,
#                                               '%H:%M:%S') -
#                             timedelta(seconds=10, minutes=2), '%H:%M:%S')

starttime = input_starttime
endtime = input_endtime

apache_servers = ['152']

for server in apache_servers:
    server_type = "Apache"
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

tomcat_servers = ['188']

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
                                                '%H:%M:%S') -
                              timedelta(seconds=30), '%H:%M:%S')
endtime = datetime.strftime(datetime.strptime(input_endtime,
                                              '%H:%M:%S') -
                            timedelta(seconds=30), '%H:%M:%S')
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
