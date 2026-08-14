#!/usr/bin/env python
import subprocess

# function to parse output of command "wpctl status" and return a dictionary of sinks with their id and name.
def parse_wpctl_status():
    # Execute the wpctl status command and store the output in a variable.
    output = str(subprocess.check_output("wpctl status", shell=True, encoding='utf-8'))

    # remove the ascii tree characters and return a list of lines
    lines = output.replace("├", "").replace("─", "").replace("│", "").replace("└", "").splitlines()

    # get the index of the Sinks line as a starting point
    sinks_index = None
    for index, line in enumerate(lines):
        if "Sinks:" in line:
            sinks_index = index
            break

    # start by getting the lines after "Sinks:" and before the next blank line and store them in a list
    sinks = []
    for line in lines[sinks_index +1:]:
        if not line.strip():
            break
        sinks.append(line.strip())

    # remove the "[vol:" from the end of the sink name
    for index, sink in enumerate(sinks):
        sinks[index] = sink.split("[vol:")[0].strip()

    # strip the * from the default sink and instead append "- Default" to the end. Looks neater in the wofi list this way.
    for index, sink in enumerate(sinks):
        if sink.startswith("*"):
            sinks[index] = sink.strip().replace("*", "").strip() + " - Default"

    # make the dictionary in this format {'sink_id': <int>, 'sink_name': <str>}
    sinks_dict = [{"sink_id": int(sink.split(".")[0]), "sink_name": sink.split(".")[1].strip()} for sink in sinks]

    return sinks_dict

# get the list of sinks ready to put into fuzzel - mark the current default sink
sinks = parse_wpctl_status()
lines = []
for items in sinks:
    if items['sink_name'].endswith(" - Default"):
        lines.append(f"-> {items['sink_name']}")
    else:
        lines.append(f"   {items['sink_name']}")
menu_input = "\n".join(lines)

# Call fuzzel (already themed via matugen, matches waybar/kitty colors) and show the list.
# --index makes it print the selected line's position instead of its text, so we don't
# need to re-match against the (possibly duplicated) sink name afterwards.
fuzzel_process = subprocess.run(
    ["fuzzel", "--dmenu", "--index", "--prompt=Salida de audio: ", "--placeholder=Elige un dispositivo"],
    input=menu_input, capture_output=True, encoding="utf-8"
)

if fuzzel_process.returncode != 0 or not fuzzel_process.stdout.strip():
    print("User cancelled the operation.")
    exit(0)

selected_sink = sinks[int(fuzzel_process.stdout.strip())]
subprocess.run(["wpctl", "set-default", str(selected_sink['sink_id'])])
