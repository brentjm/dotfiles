#!/bin/bash
# Lookup ip address and email it to yahoo mail server
# Used to send ip address of rasberry pi headless server

ip=$(ifconfig | awk -F " " '/Bcast/ {print $2}' | awk -F ":" '{print $2}')

smtp="To: brent_maranzano@yahoo.com
From: brent_maranzano@yahoo.com
Subject: ipaddress

$ip
"
echo "$smtp" > msg.txt

ssmtp brent_maranzano@yahoo.com < msg.txt

rm msg.txt
