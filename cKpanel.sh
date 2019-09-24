tmux set-window-option -g monitor-activity on

tmux set-option -g pane-active-border-fg red
tmux set-option -g pane-active-border-bg default
tmux set-option -g pane-border-fg red
tmux set-option -g pane-border-bg default

## BINDS ##

##-------##


## SESSION ##
tmux -2 new-session -d -s cKpanel
tmux -2 new-session -d -s main tty-clock
tmux -2 new-session -d -s misc /bin/bash

##-------##


## WINDOWING ##
## cKpanel
tmux -2 split-window -t cKpanel -h -p 40
tmux rename-window -t cKpanel:0 -n main
tmux rename-window -t cKpanel:1 -n misc

## Main
tmux rename-window -t main:0 -n main
tmux new-window -t main -n net

## Misc
tmux rename-window -t misc:0 -n cKterm
tmux new-window -t misc -n audio
tmux new-window -t misc -n music

## MAIN - main
tmux select-window -t main:0
tmux split-window -v -p 90
tmux split-window -v -p 50
tmux select-pane -t 0
tmux send-keys "tty-clock" Enter
tmux select-pane -t 1
tmux send-keys "gotop" Enter
tmux select-pane -t 2
tmux send-keys "/home/coke/.xmonad/waitcon.sh 1" Enter

## MAIN - net
tmux select-window -t main:1
tmux split-window -v -p 50
tmux select-pane -t 0
tmux new-window -t main:0 -n ncpa wicd-curses
tmux new-window -t main:1 -n bluetooth bluetoothctl
tmux select-window -t main:1
tmux select-pane -t 1
tmux send-keys "sudo nettop" Enter
tmux split-pane -h -p 30
tmux send-keys "sudo iptraf-ng" Enter
tmux split-pane -v -p 20
tmux send-keys "/home/coke/.xmonad/whomonitor.sh" Enter

## MISC - audio
tmux select-window -t misc:1
tmux split-window -v -p 50
tmux select-pane -t 0
tmux send-keys "alsamixer" Enter
tmux select-pane -t 1
tmux send-keys "alsamixer -D bluealsa" Enter


## MISC - music
#cava
tmux select-window -t misc:2
tmux split-window -v -p 80
tmux select-pane -t 0
tmux send-keys "cava" Enter
#mpd
tmux select-pane -t 1
tmux send-keys "ncmpcpp" Enter

## Window - selection
tmux select-window -t misc:0
tmux select-window -t main:0
##-----------##

## ATTACH ##
tmux send -t cKpanel:0 "tmux -2 attach-session -t main" Enter
tmux send -t cKpanel:1 "tmux -2 attach-session -t misc" Enter
tmux -2 attach-session -t cKpanel
tmux select-window -t cKpanel:0 
##--------##

