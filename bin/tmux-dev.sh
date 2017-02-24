#!/bin/bash
tmux start-server

tmux new-session -d -s ipython -n ipython "ipython"

tmux split-window -t 0 -h -p 70 "vi ${1}"
tmux split-window -t 0 -v 
tmux select-pane -t 1

tmux -2 attach -t ipython
