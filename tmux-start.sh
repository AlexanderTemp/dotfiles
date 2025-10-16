#!/usr/bin/env bash

SESSION="local-env"

tmux has-session -t $SESSION 2>/dev/null
if [ $? != 0 ]; then
    tmux new-session -d -s $SESSION -n iop

    tmux send-keys -t $SESSION:iop.0 "cd ~/Desktop/IOP_code/iop-v2-backend" C-m

    # División horizontal
    tmux split-window -h -t $SESSION:iop
    tmux send-keys -t $SESSION:iop.1 "cd ~/Desktop/IOP_code/iop-v2-frontend" C-m

    # División vertical
    tmux split-window -v -t $SESSION:iop.1
    tmux send-keys -t $SESSION:iop.2 "cd ~/Desktop/iop-v2-gateway" C-m

fi

tmux attach -t $SESSION

