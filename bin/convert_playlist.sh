#!/bin/bash
cat "$1" | sed -e 's|/home/userfiles/shares|S:|' | sed -e 's|/|\\|g'
