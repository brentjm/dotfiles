#!/bin/bash

# Installation of zipline
# https://github.com/quantopian/zipline
# Brent Maranzano
# 2018-07-12

sudo apt-get install libatlas-base-dev python-dev gfortran pkg-config libfreetype6-dev
pip install numpy pandas pytz Logbook requests
pip install zipline
