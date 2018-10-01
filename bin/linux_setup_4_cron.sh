#!/bin/bash
#
# Sets up cron jobs.
#
#useage:
#$sudo bash linux_setup_4_cron.sh 

function vtrim () {
# set up weekly vtrim
printf "#!/bin/bash 
LOG=/var/log/trim.log
echo \"*** (\$date -R) ***\" >> \$LOG
fstrim -v / >> \$LOG \n" > /etc/cron.weekly/trim

chmod 755 /etc/cron.weekly/trim
}

vtrim
