#!/bin/env python
# Your time elapsed of this day, month, year and this time you boot your System.
#
# by RoachHao (https://github.com/roachsinai)
# based on https://getbitbar.com/plugins/Time/progress.1h.sh
#
# python-uptime is needed

import datetime
from uptime import uptime

now = datetime.datetime.now()
year = now.year
is_leap = (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0))
bitbar = "|size=13 color=white font=Hack"


def get_uptime():
    up = uptime()
    parts = []

    days, up = up // 86400, up % 86400
    if days:
        parts.append('%d d%s' % (days, 's' if days != 1 else ''))

    hours, up = up // 3600, up % 3600
    if hours:
        parts.append('%d hour%s' % (hours, 's' if hours != 1 else ''))

    minutes = up // 60
    if minutes:
        parts.append('%d min%s' % (minutes, 's' if minutes != 1 else ''))

    print(f'Uptime: {", ".join(parts)}.{bitbar}')


def d_progress():
    beginning_of_today = datetime.datetime(now.year, now.month, now.day)
    delta = now - beginning_of_today
    percent = delta.total_seconds() / 864
    print(f"{percent:.2f}%<u></u>&nbsp;{bitbar} dropdown=false")
    print(f"Day: {percent:.2f}%.{bitbar}")
    progress(percent)


def m_progress():
    day_counts = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    if is_leap:
        day_counts[1] = 29
    beginning_of_month = datetime.datetime(now.year, now.month, 1)
    delta = now - beginning_of_month
    percent = delta.total_seconds() / (864 * day_counts[now.month - 1])
    print(f"Month: {percent:.2f}%.{bitbar}")
    progress(percent)


def y_progress():
    days_of_year = 365
    if is_leap:
        days_of_year = 366
    beginning_of_year = datetime.datetime(now.year, 1, 1)
    delta = now - beginning_of_year
    percent = delta.total_seconds() / (864 * days_of_year)
    print(f"Year: {percent:.2f}%, {delta.days + 1}days.{bitbar}")
    progress(percent)


def count_down():
    BIRTHDAT = datetime.datetime(1949, 10, 1, 0, 0)
    delta = now - BIRTHDAT
    cd_seconds = int(delta.total_seconds())
    cd_mins = cd_seconds // 60
    cd_hours = cd_mins // 60
    cd_days = cd_hours // 24

    print(f"{cd_days} days on 🇨🇳, {cd_hours}h,{bitbar}")
    print(f"{cd_mins}min, {cd_seconds}sec.{bitbar}")


def progress(percent):
    width = 25
    fill_char = "▄"
    empty_char = "▁"

    fill_width = round(percent * width / 100)
    empty_width = width - fill_width
    print(fill_char * fill_width + empty_char * empty_width + bitbar)


print("---")
get_uptime()
print("| size=6 font=Hack")
y_progress()
m_progress()
d_progress()
print("| size=6 font=Hack")
count_down()
print("| size=6 font=Hack")
print("历史上的今天| href=https://baike.baidu.com/calendar size=14 color=white font=Hack")
