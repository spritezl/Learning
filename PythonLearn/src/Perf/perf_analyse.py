# -*- coding: utf-8 -*-
"""

This is a script for generating CPU/IO/Memory/Network usage chart.
"""
import matplotlib.dates as mdates


def try_or_none(f):
    """wraps f to return None if f raises an exception
    assumes f takes only one input"""
    def f_or_none(x):
        try:
            return f(x)
        except:  # @IgnorePep8
            return None
    return f_or_none


def parse_row(input_row, parsers):
    return [try_or_none(parser)(value) if parser is not None else value
            for value, parser in zip(input_row, parsers)]


def cpu_chart(category, sourcefile, starttime, endtime,
              targetpath, targetfile):
    import dateutil.parser
    from datetime import datetime, date
    import re
    import os
    import shutil

    # sourcefile=r"D:\Project\Allocation\Load\20160118\Tomcat\189\load20160118_cpu22.txt"
    # starttime="11:28:00"
    # endtime="11:47:00"
    today = date.today().strftime("%Y-%m-%d")

    startdatetime = datetime.strptime(today + " " + starttime,
                                      "%Y-%m-%d %H:%M:%S")
    enddatetime = datetime.strptime(today + " " + endtime,
                                    "%Y-%m-%d %H:%M:%S")

    cpudata = []
    with open(sourcefile, "r") as f:
        for line in f:
            input_line = re.split(r'\s{3,}', line)
            row = parse_row(input_line,
                            [dateutil.parser.parse, None, float, float, float,
                             float, float, float])
            if not any(x is None for x in row):
                timepoint, *_ = list(zip(row))
                if (timepoint[0] >= startdatetime and
                        timepoint[0] <= enddatetime):
                    cpudata.append(row)

    # unpack cpu usage data, here _ represents the 2nd,
    # *_ represents the last ones after the 3rd one
    time, _, user_p, *_ = list(zip(*cpudata))

    # drop CPU usage image
    from matplotlib import pyplot as plt
    fig, ax = plt.subplots()
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
    fig.autofmt_xdate()
    plt.plot(time, user_p, 'g-', label=category + " CPU Usage")
    plt.title(category + " CPU usage")
    plt.ylabel("CPU usage")
    plt.ylim(0, max(user_p))
    ''' way 1'''
    # 1,rotate the x axix
#     _, labels = plt.xticks()
#     plt.setp(labels, rotation=90)

    '''way 2'''
#     plt.ylim(0, 100)
#     plt.xticks(time, [x.strftime('%H:%M:%S') for x in time], rotation=90)

    # plt.show()

    src = os.getcwd() + os.sep + targetfile
    dst = targetpath + os.sep + targetfile
    if not os.path.exists(src):
        plt.savefig(targetfile)

    if not os.path.exists(targetpath):
        os.makedirs(targetpath)

    if not os.path.exists(dst):
        shutil.move(src, dst)

    plt.close()


def io_chart(category, sourcefile, starttime, endtime, targetpath, targetfile):
    import dateutil.parser
    from datetime import datetime, date
    import re
    import os
    import shutil

    # sourcefile=r"D:\Project\Allocation\Load\20160118\Tomcat\189\load20160118_disk22.txt"
    # starttime="11:28:00"
    # endtime="11:47:00"
    today = date.today().strftime("%Y-%m-%d")

    startdatetime = datetime.strptime(today + " " + starttime,
                                      "%Y-%m-%d %H:%M:%S")
    enddatetime = datetime.strptime(today + " " + endtime,
                                    "%Y-%m-%d %H:%M:%S")

    iodata = []
    with open(sourcefile, "r") as f:
        for line in f:
            input_line = re.split(r'\s{2,}', line)
            row = parse_row(input_line,
                            [dateutil.parser.parse, None, float, float,
                             float, float, float, float, float, float])
            if not any(x is None for x in row):
                timepoint, *_ = list(zip(row))
                if (timepoint[0] >= startdatetime and
                        timepoint[0] <= enddatetime):
                    iodata.append(row)

    # unpack cpu usage data, here _ represents the 2nd,
    # *_ represents the last ones after the 3rd one
    time, _, tps, read_sec_per_s, write_sec_per_s, *_ = list(zip(*iodata))
    MBPS = list(round((r + d) * 512 / 1024 / 1024, 2)
                for r, d in zip(read_sec_per_s, write_sec_per_s))

#     # draw tps image
#     from matplotlib import pyplot as plt
#     fig, ax = plt.subplots()
#     ax.plot(time, tps, 'g-', label=category + " tps")
#     fig.autofmt_xdate()
#     fig.suptitle(category + " tps")
#     ax.set_xlabel('time')
#     ax.set_ylabel('tps')

#     # draw MBPS image
#     fig, ax = plt.subplots()
#     ax.plot(time, MBPS, 'g-', label=category + " MBPS")
#     fig.autofmt_xdate()
#     fig.suptitle(category + " MBPS")
#     ax.set_xlabel('time')
#     ax.set_ylabel('MBPS')

    from matplotlib import pyplot as plt
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    ax1.plot(time, tps, 'g-', label=category + " tps")
    ax2.plot(time, MBPS, 'r-', label=category + " MBPS")
    ax1.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
    ax2.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
    fig.autofmt_xdate()
    fig.suptitle(category + " tps and MBPS")
    ax1.set_xlabel('time')
    ax1.set_ylabel('tps')
    ax2.set_xlabel('time')
    ax2.set_ylabel('MBPS')

    # plt.show()
    src = os.getcwd() + os.sep + targetfile
    dst = targetpath + os.sep + targetfile
    if not os.path.exists(src):
        plt.savefig(targetfile)

    if not os.path.exists(targetpath):
        os.makedirs(targetpath)

    if not os.path.exists(dst):
        shutil.move(src, dst)

    plt.close()


def memory_chart(category, sourcefile, starttime, endtime,
                 targetpath, targetfile):
    import dateutil.parser
    from datetime import datetime, date
    import re
    import os
    import shutil
    # sourcefile=r"D:\Project\Allocation\Load\20160118\Tomcat\189\load20160118_memory22.txt"
    # starttime="11:28:00"
    # endtime="11:47:00"
    today = date.today().strftime("%Y-%m-%d")

    startdatetime = datetime.strptime(today + " " + starttime,
                                      "%Y-%m-%d %H:%M:%S")
    enddatetime = datetime.strptime(today + " " + endtime,
                                    "%Y-%m-%d %H:%M:%S")

    memorydata = []
    with open(sourcefile, "r") as f:
        for line in f:
            input_line = re.split(r'\s{1,}', line)
            row = parse_row(input_line,
                            [dateutil.parser.parse, None, float, float, float,
                             float, float, float])
            if not any(x is None for x in row):
                timepoint, *_ = list(zip(row))
                if (timepoint[0] >= startdatetime and
                        timepoint[0] <= enddatetime):
                    memorydata.append(row)

    # unpack cpu usage data, here _ represents the 2nd,
    # *_ represents the last ones after the 3rd one
    time, _, mem_used_in_KB, *_ = list(zip(*memorydata))
    mem_used_in_GB = list(round(u / 1000 / 1000, 1) for u in mem_used_in_KB)

    # draw Memory usage image
    from matplotlib import pyplot as plt
    fig, ax = plt.subplots()
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
    fig.autofmt_xdate()
    plt.plot(time, mem_used_in_GB, 'g-', label=category + " Memory Used")
    plt.title(category + " Memory Used")
    plt.ylabel('Memory_used_in_GB')
    plt.xlabel('time')
#     _, labels = plt.xticks()
#     plt.setp(labels, rotation=90)

    # plt.show()
    src = os.getcwd() + os.sep + targetfile
    dst = targetpath + os.sep + targetfile
    if not os.path.exists(src):
        plt.savefig(targetfile)

    if not os.path.exists(targetpath):
        os.makedirs(targetpath)

    if not os.path.exists(dst):
        shutil.move(src, dst)

    plt.close()


def network_chart(category, sourcefile, starttime, endtime,
                  targetpath, targetfile):
    import dateutil.parser
    from datetime import datetime, date
    import re
    import os
    import shutil
    # sourcefile=r"D:\Project\Allocation\Load\20160118\Tomcat\189\load20160118_network22.txt"
    # starttime="11:28:00"
    # endtime="11:47:00"
    today = date.today().strftime("%Y-%m-%d")

    startdatetime = datetime.strptime(today + " " + starttime,
                                      "%Y-%m-%d %H:%M:%S")
    enddatetime = datetime.strptime(today + " " + endtime,
                                    "%Y-%m-%d %H:%M:%S")

    networkdata = []
    with open(sourcefile, "r") as f:
        for line in f:
            input_line = re.split(r'\s{2,}', line)
            row = parse_row(input_line,
                            [dateutil.parser.parse, None, float,
                             float, float, float, float, float, float])
            if not any(x is None for x in row):
                timepoint, *_ = list(zip(row))
                if (timepoint[0] >= startdatetime and
                        timepoint[0] <= enddatetime):
                    networkdata.append(row)

    # unpack cpu usage data, here _ represents the 2nd,
    # *_ represents the last ones after the 3rd one
    time, _, _, _, receive_kb_per_s, transfer_kb_per_s, *_ = list(zip(*networkdata))  # @IgnorePep8
    troughout_kb_per_s = list(round(r + t, 2)
                              for r, t in zip(receive_kb_per_s,
                                              transfer_kb_per_s))

    # draw tps image
    from matplotlib import pyplot as plt
    fig, ax = plt.subplots()
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
    ax.plot(time, troughout_kb_per_s, 'g-',
            label=category + ' Network throughout per second')
    fig.autofmt_xdate()
    fig.suptitle(category + ' Network throughout(KB/s)')
    ax.set_xlabel('time')
    ax.set_ylabel('throughout per second(KB/s)')

    # plt.show()
    src = os.getcwd() + os.sep + targetfile
    dst = targetpath + os.sep + targetfile
    if not os.path.exists(src):
        plt.savefig(targetfile)

    if not os.path.exists(targetpath):
        os.makedirs(targetpath)

    if not os.path.exists(dst):
        shutil.move(src, dst)

    plt.close()


def queue_chart(category, sourcefile, starttime, endtime,
                targetpath, targetfile):
    import dateutil.parser
    from datetime import datetime, date
    import re
    import os
    import shutil

    # sourcefile=r"D:\Project\Allocation\Load\20160118\Tomcat\189\load20160118_queue22.txt"
    # starttime="11:28:00"
    # endtime="11:47:00"
    today = date.today().strftime("%Y-%m-%d")

    startdatetime = datetime.strptime(today + " " + starttime,
                                      "%Y-%m-%d %H:%M:%S")
    enddatetime = datetime.strptime(today + " " + endtime,
                                    "%Y-%m-%d %H:%M:%S")

    queuedata = []
    with open(sourcefile, "r") as f:
        for line in f:
            input_line = re.split(r'\s{2,}', line)
            row = parse_row(input_line,
                            [dateutil.parser.parse, float, float,
                             float, float, float])
            if not any(x is None for x in row):
                timepoint, *_ = list(zip(row))
                if (timepoint[0] >= startdatetime and
                        timepoint[0] <= enddatetime):
                    queuedata.append(row)

    # unpack cpu usage data, here _ represents the 2nd,
    # *_ represents the last ones after the 3rd one
    time, runq_size, *_ = list(zip(*queuedata))

    # drop process queue image
    from matplotlib import pyplot as plt
    fig, ax = plt.subplots()
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))
    fig.autofmt_xdate()
    plt.plot(time, runq_size, 'g-', label=category + ' process queue')
    plt.title(category + " process queue")
    plt.ylabel(category + " process queue")
    plt.xlabel('time')

    # 1,rotate the x axix
    plt.ylim(0, max(runq_size))
#     _, labels = plt.xticks()
#     plt.setp(labels, rotation=90)

    # plt.show()
    src = os.getcwd() + os.sep + targetfile
    dst = targetpath + os.sep + targetfile
    if not os.path.exists(src):
        plt.savefig(targetfile)

    if not os.path.exists(targetpath):
        os.makedirs(targetpath)

    if not os.path.exists(dst):
        shutil.move(src, dst)

    plt.close()
