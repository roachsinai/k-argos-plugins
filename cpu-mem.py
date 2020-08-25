#!/usr/bin/env python3
import psutil

cpus = psutil.cpu_percent(interval=1, percpu=True)
total = 0
for cpu in cpus:
    total += cpu
avg = total / len(cpus)

stats = psutil.virtual_memory()
mem = stats.percent


def show(val):
    color = '#cc575d' if val > 75 else '#d19a66' if val > 50 else '#68b382'
    return "<font_color='%s'>%2d%%</font>" % (color,val)

print(  '<br>c:%s<br>m:%s| font=monospace' %
      ( show(avg).replace(" ","&nbsp;").replace("_"," "), show(mem).replace(" ","&nbsp;").replace("_"," ") )  )



print("---")


def size(bytes):
    suffix = 'B'
    if bytes > 1024:
        bytes /= 1024
        suffix = 'K'
    if bytes > 1024:
        bytes /= 1024
        suffix = 'M'
    if bytes > 1024:
        bytes /= 1024
        suffix = 'G'
    return "%8.2f%s" % (bytes, suffix)

for i, cpu in enumerate(cpus):
    print("CPU %d: %s|font=monospace" % (i, show(cpu)))

print("")
print("MEMORY")
print("Total:     %s|font=monospace" % size(stats.total))
print("Available: %s|font=monospace" % size(stats.available))
print("Used:      %s|font=monospace" % size(stats.used))
print("Buffers:   %s|font=monospace" % size(stats.buffers))
print("Cached:    %s|font=monospace" % size(stats.cached))
print("Shared:    %s|font=monospace" % size(stats.shared))
