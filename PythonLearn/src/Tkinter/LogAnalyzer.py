'''
Created on Sep 19, 2016

@author: fzhang
'''

from tkinter import *  # @UnusedWildImport
from tkinter import ttk  # @Reimport
from tkinter import filedialog  # @Reimport
from datetime import date, timedelta, datetime


def calcActivity(logentities):
    import sqlite3

    conn = sqlite3.connect(':memory:')
    cur = conn.cursor()
    cur.execute('''CREATE TABLE IF NOT EXISTS LogEntities(
    actiondate DATETIME,
    username TEXT)''')

    cur.executemany('insert into LogEntities values(?,?)', logentities)
    conn.commit()

    userActivities = []
    for (actionmin, user_count) in cur.execute("""
    select strftime('%Y-%m-%d %H:%M',actiondate),count(distinct username)
    from LogEntities
    group by strftime('%Y-%m-%d %H:%M',actiondate)
    order by 1"""):
        userActivities.append((datetime.strptime(actionmin + ':00',
                                                 '%Y-%m-%d %H:%M:%S'),
                               user_count))
    cur.close()
    conn.close()
    return userActivities


def activityChart(activitydata, savedir):
    minute, usercount = list(zip(*activitydata))
    from matplotlib import pyplot as plt
    fig, ax = plt.subplots()
    ax.plot(minute, usercount, 'g-',
            label='User Activity by minute')
    fig.autofmt_xdate()
    fig.suptitle('User Activity by minute')
    ax.set_xlabel('minute')
    ax.set_ylabel('concurrent user#')
    _, labels = plt.xticks()
    plt.setp(labels, rotation=90)
    plt.ylim(0, 30)
    # plt.show()

    import os
    import shutil
    targetfile = "useractivity.png"
    src = os.getcwd() + os.sep + targetfile
    dst = savedir + os.sep + targetfile
    if not os.path.exists(src):
        plt.savefig(targetfile)

    if not os.path.exists(dst):
        shutil.move(src, dst)

    plt.close()


def extractLog(logWriterFile, starttime, endtime):

    logentities = []
    pattern = re.compile(r'\[(.*)\]+\s(user\s\w+),+\s.*$')

    with open(logWriterFile, "r", encoding='latin1') as f:
        for line in f:
            match = re.match(pattern, line)
            if match:
                actiondate = datetime.strptime(
                    match.group(1).replace('CST ', ''),
                    "%a %b %d %H:%M:%S %Y")
                username = match.group(2)
                if (actiondate >= starttime and
                        actiondate <= endtime):
                    logentities.append((actiondate, username))

    return logentities


def doSelectLogSource():
    filename = filedialog.askopenfilename()
    logSource.set(filename)


def doSaveToDir():
    dirname = filedialog.askdirectory()
    chartDir.set(dirname)


def doGenerate():
    s = str(starttime_entry.get())
    e = str(endtime_entry.get())
    l = str(logsource_entry.get())
    c = str(chartdir_entry.get())
    activityChart(calcActivity(
        extractLog(l,
                   datetime.strptime(s, '%Y-%m-%d %H:%M:%S'),
                   datetime.strptime(e, '%Y-%m-%d %H:%M:%S')
                   )), c)


root = Tk()
root.title("Log Analyzer")
mainframe = ttk.Frame(root, padding="3 3 3 3")
mainframe.grid(column=0, row=0, sticky=(N, W, E, S))

ttk.Label(mainframe,
          text="LogWriterLog File:").grid(row=0, column=0, sticky=(W, N))

logSource = StringVar()
logsource_entry = ttk.Entry(mainframe, textvariable=logSource)
logsource_entry.grid(row=0, column=1, sticky=(W, E))
ttk.Button(mainframe,
           text="Select",
           command=doSelectLogSource
           ).grid(row=0, column=2)

ttk.Label(mainframe,
          text="Save Chart To Dir:").grid(row=1, column=0, sticky=(W, N))
chartDir = StringVar()
chartdir_entry = ttk.Entry(mainframe, textvariable=chartDir)
chartdir_entry.grid(row=1, column=1, sticky=(W, E))
ttk.Button(mainframe,
           text="SaveDir",
           command=doSaveToDir
           ).grid(row=1, column=2)

ttk.Label(mainframe,
          text="Start Time:").grid(row=2, column=0, sticky=(W, N))
starttime = StringVar()
starttime.set(date.today().strftime("%Y-%m-%d") + " 00:00:00")
starttime_entry = ttk.Entry(mainframe, textvariable=starttime)
starttime_entry.grid(row=2, column=1, sticky=(W, E))

ttk.Label(mainframe,
          text="End Time:").grid(row=3, column=0, sticky=(W, N))
endtime = StringVar()
endtime.set((date.today() + timedelta(days=1)).strftime("%Y-%m-%d") +
            " 00:00:00")
endtime_entry = ttk.Entry(mainframe, textvariable=endtime)
endtime_entry.grid(row=3, column=1, sticky=(W, E))

ttk.Button(mainframe,
           text="Generate",
           command=doGenerate).grid(row=4, column=2)

root.columnconfigure(0, weight=1)
root.rowconfigure(0, weight=1)
mainframe.columnconfigure(0, weight=0)
mainframe.columnconfigure(1, weight=3)
mainframe.columnconfigure(2, weight=0)

root.mainloop()
