'''
Created on Sep 14, 2016
This is a little utility to analyze LogWriterLog for user activities by minute.

@author: fzhang
'''
from datetime import datetime


def calcActivity(logentities):
    import sqlite3
#   from datetime import datetime
#     logentities = [(datetime.strptime('Tue Sep 13 12:00:10 2016',
#                                       "%a %b %d %H:%M:%S %Y"),
#                     'user ACQ'),
#                    (datetime.strptime('Tue Sep 13 12:00:15 2016',
#                                       "%a %b %d %H:%M:%S %Y"),
#                     'user ANanchang'),
#                    (datetime.strptime('Tue Sep 13 12:00:15 2016',
#                                       "%a %b %d %H:%M:%S %Y"),
#                     'user ANanchang')]

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
        # print(actionmin+'|'+str(user_count))
        userActivities.append((datetime.strptime(actionmin+':00',
                                                 '%Y-%m-%d %H:%M:%S'),
                               user_count))
    cur.close()
    conn.close()
    return userActivities


def activityChart(activitydata):
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
    plt.show()


def extractLog(logWriterFile, starttime, endtime):
    import re
#   from datetime import datetime

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


# test with actual time range
activityChart(calcActivity(extractLog(
    r'D:\Project\Allocation\Load\20160918\LogWriterLog203.txt',
    datetime.strptime('2016-09-13 00:00:00', '%Y-%m-%d %H:%M:%S'),
    datetime.strptime('2016-09-14 00:00:00', '%Y-%m-%d %H:%M:%S'))))
