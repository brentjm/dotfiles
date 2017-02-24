#!/bin/bash
# Modifies configurations
#
#useage:
#$sudo bash linux_setup_configuration_settings.sh 

function nautilus() {
    # Modify the nautilus views
    gsettings set org.gnome.nautilus.list-view use-tree-view true
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
    gsettings set org.gnome.nautilus.list-view default-zoom-level smaller
    gsettings set org.gnome.nautilus.preferences show-hidden-files true
}

nautilus
