#!/usr/bin/env python3
import calendar
import datetime
import json
import re
from pathlib import Path

MONTHS = ["January", "February", "March", "April", "May", "June", "July",
          "August", "September", "October", "November", "December"]
DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
WEEKDAYS = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
WIDTH = 20
GAP = "    "


def theme():
    colors = {"primary": "#bece80", "on_surface": "#e4e3d7",
              "primary_container": "#3f4c0b", "on_primary_container": "#d9eb99"}
    path = Path.home() / ".config/matugen/colors.css"
    if path.exists():
        colors.update(re.findall(r"@define-color (\w+) (#[0-9a-fA-F]{6});", path.read_text()))
    return colors


def span(text, **attrs):
    return "<span " + " ".join(f"{k}='{v}'" for k, v in attrs.items()) + f">{text}</span>"


def month_lines(year, month, today, c):
    current = (year, month) == (today.year, today.month)
    alpha = "100%" if current else "45%"
    title = f"{MONTHS[month - 1]} {year}".center(WIDTH)
    lines = [span(title, foreground=c["primary"], weight="bold", fgalpha=alpha),
             span(" ".join(WEEKDAYS), foreground=c["on_surface"], fgalpha="50%")]
    weeks = calendar.Calendar(firstweekday=0).monthdayscalendar(year, month)
    weeks += [[0] * 7] * (6 - len(weeks))
    for week in weeks:
        cells = []
        for i, day in enumerate(week):
            text = f"{day:>2}" if day else "  "
            if current and day == today.day:
                cells.append(span(text, background=c["primary"], foreground="#000000", weight="bold"))
            elif i >= 5:
                cells.append(span(text, foreground=c["primary"], fgalpha=alpha))
            else:
                cells.append(span(text, foreground=c["on_surface"], fgalpha=alpha))
        lines.append(" ".join(cells))
    return lines


def main():
    now = datetime.datetime.now()
    today = now.date()
    c = theme()
    prev = today.replace(day=1) - datetime.timedelta(days=1)
    nxt = today.replace(day=28) + datetime.timedelta(days=4)
    side = zip(month_lines(prev.year, prev.month, today, c), month_lines(nxt.year, nxt.month, today, c))
    pad = " " * ((WIDTH * 2 + len(GAP) - WIDTH) // 2)
    body = ("\n".join(pad + line for line in month_lines(today.year, today.month, today, c))
            + "\n\n" + "\n".join(GAP.join(parts) for parts in side))
    heading = f"{DAYS[today.weekday()]}, {MONTHS[today.month - 1]} {today.day}, {today.year}"
    heading = heading.center(WIDTH * 2 + len(GAP))
    tooltip = span(span(heading, foreground=c["primary"], weight="bold") + "\n\n" + body,
                   font_family="FantasqueSansM Nerd Font Mono")
    print(json.dumps({"text": now.strftime("%a %d %b  %H:%M"), "tooltip": tooltip}))


if __name__ == "__main__":
    main()
