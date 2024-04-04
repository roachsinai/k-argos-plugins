#!/Users/tal/.venv/util/bin/python3
import psutil
import time
import os

count = psutil.net_io_counters()
recv, sent = count.bytes_recv, count.bytes_sent
time.sleep(1)
count = psutil.net_io_counters()
recv, sent = count.bytes_recv - recv, count.bytes_sent - sent

stats = psutil.net_if_stats()


def size(bytes, high, medium):
    # color = '#cc575d' if bytes > high else '#d19a66' if bytes > medium else '#68b382'
    if bytes > 1024**3:
        bytes /= 1024**3
        suffix = 'G'
        return "%4.1f%s" % (bytes, suffix)
    if bytes > 1024**2:
        bytes /= 1024**2
        suffix = 'M'
        return "%4.1f%s" % (bytes, suffix)
    if bytes > 1024:
        bytes /= 1024
        suffix = 'K'
        return "%4d%s" % (bytes, suffix)
    suffix = 'B'
    return "%4d%s" % (bytes, suffix)

print('↑↓ %s' %
      (size(max(sent, recv), 8000000, 1000000).replace("_"," ") )  )
 
 
# print ("---")
# 
# out = os.popen("sudo nethogs -t -c 2 | tail -n +9").read()
# 
# print("PROCESS\tSENT\tRECEIVED")
# print( '%s' % out.replace('\n',"<br>") )
