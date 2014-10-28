#!/usr/bin/env bash

# Update Repositories
sudo apt-get update

# Determine Ubuntu Version
. /etc/lsb-release

# Decide on package to install for `add-apt-repository` command
#
# USE_COMMON=1 when using a distributino over 12.04
# USE_COMMON== when using a distribution older or at 12.04
USE_COMMON=$(echo "$DISTRIB_RELEASE > 12.04" | bc)

if [ "$USE_COMMON" -eq "1" ];
then
    sudo apt-get install -y software-properties-common
else
    sudo apt-get install -y python-software-properties
fi

# Add Ansible Repository & Install Ansible
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

# Setup Ansible for Local Use and Run
cp /vagrant/ansible/inventories/dev /etc/ansible/hosts -f
chmod 666 /etc/ansible/hosts
cat /vagrant/ansible/files/authorized_keys >> /home/vagrant/.ssh/authorized_keys
sudo ansible-playbook /vagrant/ansible/playbook.yml --connection=local