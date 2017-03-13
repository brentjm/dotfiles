#!/bin/bash
tmux start-server

tmux new-session -d -s ipython -n ipython "ipython"

tmux -2 attach -t ipython
