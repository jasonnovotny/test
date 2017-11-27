#!/bin/bash
#set -x
#set -e

echo "Setting up LinuxFreak.com test web-server and database.."

# Must run script as root
function check_root {
	if [ $EUID -ne 0 ]; then
    		echo -e "\nScript not running as root, exiting setup"
    		exit 2
	fi
}

# Check for CentOS7/Red Hat
function check_version {
	grep "Red Hat" /proc/version
	if [ $? != "0" ]; then
		echo -e "\nCentOS / Red Hat system not detected, exiting setup"
		exit 2
	fi
}

function web_svr_setup {
	# nginx install/setup sourced from: https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7
	# Add EPEL repo
	yum install epel-release -y
	yum install nginx -y
	systemctl start nginx
	systemctl enable nginx
	firewall-cmd --permanent --zone=public --add-service=http 
	firewall-cmd --permanent --zone=public --add-service=https
	firewall-cmd --reload

	#Default server root: /usr/share/nginx/html
	#Defualt server block config file: /etc/nginx/conf.d/default.conf
	#Additional server blocks, known as Virtual Hosts in Apache,
	# can be added by creating new conf files in /etc/nginx/conf.d.
	# Files that end with .conf in that directory will be loaded when Nginx is started.
	# The main Nginx configuration file is located at: /etc/nginx/nginx.conf

	cp -rf linuxfreak.com /usr/share/nginx
	cp -f conf_files/linuxfreak.com.conf /etc/nginx/conf.d
	systemctl reload nginx.service
	firefox linuxfreak.com &
}

# mysql install/setup

# Configure SeLinux

# PRIMARY FUNCTION CALLS
check_root
check_version
web_svr_setup