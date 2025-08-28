#!/usr/bin/env bash
# AUTHOR: gotbletu (@gmail|twitter|youtube|github|lbry)
#         https://www.youtube.com/user/gotbletu
# DESC:   turn any terminal into a dropdown terminal
# DEMO:   https://www.youtube.com/watch?v=mVw2gD9iiOg
# DEPEND: kdotool (https://github.com/jinliu/kdotool)
# CLOG:   2025-08-27   add num_displays check to scale term to fit on 1st display, by @Fluffisaurus
#         2025-08-25   rewrite for kde plasma wayland by @Fluffisaurus
#         2022-03-05   else statement to allow terminal to jump to current virtual desktop if is visible on another desktop
#         2022-02-28   added auto launch terminal if none running by https://github.com/aaccioly
#         2021-02-10   use comm to match window name and class, this avoids terminal windows with different names
#         2015-02-15   0.1

# get working screen resolution, excludes task bar
work_area=$(xprop -root | grep _NET_WORKAREA)
width=$(echo $work_area | awk -F', ' '{print $3}')
height=$(echo $work_area | awk -F', ' '{print $4}')

scale=2 # your current display scale, ex 200% = 2
num_displays=$(xrandr | grep " connected" | wc -l)
if [[ "$num_displays" > 1 ]]; then
    scale=$(expr $scale * $num_displays)
fi
effective_width=$(expr $width / $scale)
effective_height=$(expr $height / $scale)

# option 1: set terminal emulator manually
# my_term=urxvt
# my_term=sakura
# my_term="alacritty"
# my_term=terminator
# my_term=gnome-terminal
my_term="konsole"
# my_term="kitty"

# option 2: auto detect terminal emulator (note: make sure to only open one)
# my_term="urxvt|kitty|xterm|uxterm|termite|sakura|lxterminal|terminator|mate-terminal|pantheon-terminal|konsole|gnome-terminal|xfce4-terminal"

if [[ "$my_term" = "kitty" ]]; then
    # get KWin internal window id for terminal, format: {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}
    pid=$(kdotool search --class "$my_term" | tail -n1)
else 
    # get KWin internal window id for terminal emulator and matching name pid, format: {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}
    pid=$(comm -12 <(kdotool search --name "$my_term" | sort) <(kdotool search --class "$my_term" | sort))
fi
    
# start a new terminal if none is currently running
if [[ -z "$pid" ]]; then
    while IFS='|' read -ra TERMS; do
        for candidate_term in "${TERMS[@]}"; do
            if command -v "$candidate_term" &>/dev/null; then
                ${candidate_term} &>/dev/null &
                disown
                pid=$!
                break
            fi
        done
    done <<<"$my_term"
else
    # get active window id
    aid=$(kdotool getactivewindow)

    # minimize if active_window_process_id is my_term_pid
    if [[ "$pid" = "$aid" ]]; then
        kdotool windowminimize $pid
    else
        did=$(kdotool get_desktop)
        kdotool set_desktop_for_window $pid $did
        kdotool windowactivate $pid
        kdotool windowmove $pid 0 0
        kdotool windowsize $pid $effective_width $effective_height
    fi
fi
