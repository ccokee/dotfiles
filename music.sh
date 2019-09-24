#!/bin/bash

SESSION=$USER

tmux -2 new-session -d -s $SESSION

tmux new-window -t $SESSION:1
tmux split-window -v
tmux select-pane -t 0
tmux resize-pane -y 8
tmux send-keys "cava" Enter
tmux select-pane -t 1
tmux send-keys "ncmpcpp" Enter

tmux -2 attach-session -t $SESSION
