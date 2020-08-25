#!/usr/bin/env python3
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
    color = '#cc575d' if bytes > high else '#d19a66' if bytes > medium else '#68b382'
    if bytes > 1024**3:
        bytes /= 1024**3
        suffix = 'G'
        return "<font_color='%s'>%4.1f%s</font>" % (color, bytes, suffix)
    if bytes > 1024**2:
        bytes /= 1024**2
        suffix = 'M'
        return "<font_color='%s'>%4.1f%s</font>" % (color, bytes, suffix)
    if bytes > 1024:
        bytes /= 1024
        suffix = 'K'
        return "<font_color='%s'>%4d%s</font>" % (color, bytes, suffix)
    suffix = 'B'
    return "<font_color='%s'>%4d%s</font>" % (color, bytes, suffix)

print(  '<br>%s↑<br>%s↓ | font=monospace' %
      ( size(sent, 1000000, 250000).replace(" ","&nbsp;").replace("_"," "), size(recv, 8000000, 1000000).replace(" ","&nbsp;").replace("_"," ") )  )


print ("---")

out = os.popen("sudo nethogs -t -c 2 | tail -n +9").read()

print("PROCESS\tSENT\tRECEIVED")
print( '%s' % out.replace('\n',"<br>") )

