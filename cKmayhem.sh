#!/bin/bash

tmux -2 new-session -d -s Mayhem

tmux rename-window -t Mayhem:0 Localhost
tmux new-window -t Mayhem -n cKmayhem

tmux split-window -t Mayhem:0.0 -h -p 50
tmux split-window -t Mayhem:1.0 -h -p 100
tmux split-window -t Mayhem:1.1 -v -p 50
tmux split-window -t Mayhem:1.1 -h -p 100
tmux split-window -t Mayhem:1.3 -h -p 100

tmux send-keys -t Mayhem:0.1 "sleep 1 && clear" Enter
tmux send-keys -t Mayhem:1.1 "while true; do clear && /home/coke/.xmonad/waitcon.sh 2; sleep 1" Enter
tmux send-keys -t Mayhem:1.2 "while true; do clear && /home/coke/.xmonad/waitcon.sh 3; sleep 1" Enter
tmux send-keys -t Mayhem:1.3 "while true; do clear && /home/coke/.xmonad/waitcon.sh 4; sleep 1" Enter
tmux send-keys -t Mayhem:1.4 "while true; do clear && /home/coke/.xmonad/waitcon.sh 5; sleep 1" Enter

tmux select-window -t Mayhem:0.0
tmux -2 attach-session -t Mayhem
