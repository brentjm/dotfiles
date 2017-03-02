#!/bin/bash

# Remove anaconda3 from the system PATH.
# Useful if running virtualenv.

PATH=$(echo "$PATH" | sed -e 's/:*\/home\/brent\/anaconda3\/bin:*//')
export PATH="$PATH"
