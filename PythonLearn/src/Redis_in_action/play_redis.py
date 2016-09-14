# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 14:29:16 2016

try redis via python

@author: fzhang
"""


def cache_scs():
    # it takes 128s to put 110k style_color_size & source_buskey into a hash
    # 2016-03-31 15:48:28
    # 2016-03-31 15:50:36
    # 128.612693
    import redis
    import cx_Oracle
    # from datetime import datetime
    oracle_conn = cx_Oracle.connect('beta/sol@10.125.2.236/bspos')
    redis_conn = redis.Redis(host='10.125.2.241', port=6379)
    cur = oracle_conn.cursor()
    sql = 'SELECT STYLE_COLOR_SIZE_ID,SOURCE_BUSKEY FROM DIM_STYLE_COLOR_SIZE'
    cur.execute(sql)
    # starttime = datetime.now()
    # print(starttime.strftime('%Y-%m-%d %H:%M:%S'))
    for row in cur:
        redis_conn.hset('STYLE_COLOR_SIZE', row[0], row[1])
    # endtime = datetime.now()
    # print(endtime.strftime('%Y-%m-%d %H:%M:%S'))
    # elapsed = endtime - starttime
    # print(elapsed.total_seconds())
    cur.close()
    oracle_conn.close()


def cache_scs_in_json():
    '''
    it takes 129s to populate 110k style_color_size
    into redis with value as json
    '''
    import cx_Oracle
    import json
    import redis
    # from datetime import datetime
    oracle_conn = cx_Oracle.connect('beta/sol@10.125.2.236/bspos')
    redis_conn = redis.Redis(host='10.125.2.241', port=6379)
    cur = oracle_conn.cursor()
    sql = 'SELECT * FROM DIM_STYLE_COLOR_SIZE'
    cur.execute(sql)
    cols = list(d[0] for d in cur.description)
    # starttime = datetime.now()
    for row in cur:
        content = dict(zip(cols[1:], row[1:]))
        redis_conn.hset('STYLE_COLOR_SIZE', row[0], json.dumps(content))
    # endtime = datetime.now()
    # elapsed = endtime - starttime
    # print(elapsed.total_seconds())
    cur.close()
    oracle_conn.close()


def cache_scs_injson_pipeline():
    '''
    it takes 9s to populate 110k style_color_size IN PIPELINE MODE
    into redis with value as json
    '''
    import cx_Oracle
    import json
    import redis
    # from datetime import datetime
    oracle_conn = cx_Oracle.connect('beta/sol@10.125.2.236/bspos')
    redis_conn = redis.Redis(host='10.125.2.241', port=6379)
    pipe = redis_conn.pipeline(True)
    cur = oracle_conn.cursor()
    sql = 'SELECT * FROM DIM_STYLE_COLOR_SIZE'
    cur.execute(sql)
    cols = list(d[0] for d in cur.description)
    # starttime = datetime.now()
    for row in cur:
        content = dict(zip(cols[1:], row[1:]))
        pipe.hset('STYLE_COLOR_SIZE', row[0], json.dumps(content))
    pipe.execute()
    # endtime = datetime.now()
    # elapsed = endtime - starttime
    # print(elapsed.total_seconds())
    cur.close()
    oracle_conn.close()


if __name__ == '__main__':
    import timeit
    print(timeit.timeit('cache_scs_injson_pipeline()',
                        setup="from __main__ import cache_scs_injson_pipeline",
                        number=1))
