'''
Created on Sep 19, 2016

@author: fzhang
'''

from tkinter import *  # @UnusedWildImport
from tkinter import ttk  # @Reimport
from tkinter import filedialog  # @Reimport
from tkinter import messagebox  # @Reimport
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


def saveToCSV(activitydata, savedir):
    import os
    import csv
    targetfile = "useractivity.csv"
    dst = savedir + os.sep + targetfile

    if not activitydata:
        messagebox.showinfo(message="""No activity data,
        please re-input the start date and end date""", title='LogAnalyzer')

    if not savedir:
        messagebox.showinfo(message="""No target dir choosed""",
                            title='LogAnalyzer')

    if os.path.exists(dst):
        os.remove(dst)

    fieldsnames = ['minute', 'current_users']
    with open(dst, "w", newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldsnames)
        writer.writeheader()
        for x, y in activitydata:
            writer.writerow({'minute': x, 'current_users': y})


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
    saveToCSV(calcActivity(
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
          text="Save csv To Dir:").grid(row=1, column=0, sticky=(W, N))
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
