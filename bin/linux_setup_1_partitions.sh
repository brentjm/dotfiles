#!/bin/bash
#
# Functions:
#    function mkdirs - create directories in the /home directory for other data
#    function SSD - configure the mount settings for the solid state drive
#
#useage:
#$sudo bash linux_setup_1_partisions.sh 


function makedirs () {
# Make directories in the /home directory for userfiles and virtuals
for dir in "userfiles" "virtuals"
do
    mkdir /home/$dir
    chown brent:users /home/$dir
done
}


function fstab_mounts () { 
# Edit the /etc/fstab file to mount the userfiles virtuals, and mythtv partitions
# args:

# mount userfiles
sed -ie "\$a# userfiles" /etc/fstab
size=$(blkid -o full | grep userfiles | awk '{print $3'} | wc | awk '{print $3}')
end=$((size-2))
UUID=$(blkid -o full |  grep userfiles | awk '{print $3}' | cut -c 7-42)
sed -ie "\$aUUID=$UUID    /home/userfiles    ext4    defaults    0    2" /etc/fstab

# mount virtuals
sed -ie "\$a# virtuals" /etc/fstab
size=$(blkid -o full | grep virtuals | awk '{print $3'} | wc | awk '{print $3}')
end=$((size-2))
UUID=$(blkid -o full |  grep virtuals | awk '{print $3}' | cut -c 7-42)
sed -ie "\$aUUID=$UUID    /home/virtuals    ext4    defaults    0    2" /etc/fstab

# check if everything works
mount --fake --verbose --all
}


function SSD () { 
# Configure the mount for the Solid State Drive to maximize performance
# Should look like this when correctly performed
# UUID=1ceae526-274d-4527-9bd7-aad6df671b6b /    ext4    errors=remount-ro,noatime 0       1
sed -e '/ \/ *ext4/ s|remount-ro|remount-ro,noatime|' /etc/fstab
}

makedirs
fstab_mounts
SSD
