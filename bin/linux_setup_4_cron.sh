#!/bin/bash
#
# Sets up cron jobs.
#
#useage:
#$sudo bash linux_setup_cron.sh 

function vtrim () {
# set up daily vtrim
printf "#!/bin/bash 
LOG=/var/log/trim.log
echo \"*** (\$date -R) ***\" >> \$LOG
fstrim -v / >> \$LOG \n" > /etc/cron.daily/trim

chmod 755 /etc/cron.daily/trim
}

vtrim
