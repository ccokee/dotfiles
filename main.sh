#!/bin/bash

tmux -2 new-session -d -s Main
tmux rename-window -t Main network
tmux new-window -t Main -n bitchX
tmux new-window -t Main -n monitor

# network #
tmux select-window -t Main:0
tmux split-window -v -p 78
tmux split-window -v -p 10
tmux select-pane -t 2
tmux split-window -h -p 38

tmux select-pane -t 0
tmux send-keys "wicd-curses" Enter
tmux select-pane -t 1
tmux send-keys "screen sleep 1; /home/coke/.xmonad/waitcon.sh 9" Enter
tmux select-pane -t 2
tmux send-keys "/home/coke/.xmonad/waitcon.sh 10" Enter
tmux select-pane -t 3
tmux send-keys "/home/coke/.xmonad/whomonitor.sh" Enter

# bitchX # 
tmux select-window -t Main:1
tmux split-window -v -p 90
tmux select-pane -t 0 
tmux send-keys "screen sleep 1; tty-clock -csBSnr -C 1" Enter
tmux select-pane -t 1
tmux send-keys "/home/coke/.xmonad/waitcon.sh 1" Enter

# monitor #
tmux select-window -t Main:2
tmux split-window -v -p 90
tmux select-pane -t 0
tmux send-keys "screen sleep 1; tty-clock -csBSnr -C 1" Enter
tmux select-pane -t 1
tmux send-keys "gotop" Enter


tmux -2 attach-session -t Main

