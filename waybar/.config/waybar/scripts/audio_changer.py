#!/usr/bin/env python
import subprocess

def parse_wpctl_status():
    output = str(subprocess.check_output("wpctl status", shell=True, encoding='utf-8'))

    lines = output.replace("├", "").replace("─", "").replace("│", "").replace("└", "").splitlines()

    sinks_index = None
    for index, line in enumerate(lines):
        if "Sinks:" in line:
            sinks_index = index
            break

    sinks = []
    for line in lines[sinks_index +1:]:
        if not line.strip():
            break
        sinks.append(line.strip())

    for index, sink in enumerate(sinks):
        sinks[index] = sink.split("[vol:")[0].strip()

    for index, sink in enumerate(sinks):
        if sink.startswith("*"):
            sinks[index] = sink.strip().replace("*", "").strip() + " - Default"

    sinks_dict = [{"sink_id": int(sink.split(".")[0]), "sink_name": sink.split(".")[1].strip()} for sink in sinks]

    return sinks_dict

sinks = parse_wpctl_status()
lines = []
for items in sinks:
    if items['sink_name'].endswith(" - Default"):
        lines.append(f"-> {items['sink_name']}")
    else:
        lines.append(f"   {items['sink_name']}")
menu_input = "\n".join(lines)

fuzzel_process = subprocess.run(
    ["fuzzel", "--dmenu", "--index", "--prompt=Salida de audio: ", "--placeholder=Elige un dispositivo"],
    input=menu_input, capture_output=True, encoding="utf-8"
)

if fuzzel_process.returncode != 0 or not fuzzel_process.stdout.strip():
    print("User cancelled the operation.")
    exit(0)

selected_sink = sinks[int(fuzzel_process.stdout.strip())]
subprocess.run(["wpctl", "set-default", str(selected_sink['sink_id'])])
