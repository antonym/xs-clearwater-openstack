#!/bin/sh
clear
# get server information
function get_host_info {
        echo "Openstack XenServer Post Install:"
        echo
        read -p "Host IP => " PRIMARYIP
        read -p "Host Netmask => " PRIMARYNM
        read -p "Host Gateway => " PRIMARYGW
        read -p "Host DNS => " DNS
        echo
        echo You entered:
        echo
        echo "Host IP:          $PRIMARYIP"
        echo "Host Netmask:     $PRIMARYNM"
	echo "Host Gateway:	$PRIMARYGW"
        echo "Host DNS:         $DNS"
}

function confirm_host {
        read -p "Is this correct? [Y/N]: " answer_host

        case "$answer_host" in
                [yY1] ) eval "$choice_yes"
                    # error check
                    ;;
                [nN0] ) eval "$choice_no"
                    # error check
                    get_host_info
                    clear
                    ;;
                *     ) confirm_host ;;
        esac
}

get_host_info
confirm_host

# sync time
echo Syncing time...
ntpdate pool.ntp.org > /dev/null

# base host configs, /root overlay
echo "Obtaining overlay..."
wget http://kickstart/xenserver/xs-clearwater/configs/overlay.tgz -O /overlay.tgz > /dev/null

# Validate overlay was obtained
if [ -f /overlay.tgz ]
  then
    echo > /dev/null
  else
    echo "overlay was not downloaded correctly, please reinstall."
    sleep 10000000
    exit 0
fi

# extract
cd /
tar zxf overlay.tgz
rm /overlay.tgz

# inject networking config for mgmt
cat > "/etc/firstboot.d/data/management.conf" <<EOF
LABEL='eth0'
MODE='static'
IP='$PRIMARYIP'
NETMASK='$PRIMARYNM'
GATEWAY='$PRIMARYGW'
DNS1='$DNS'
EOF

# create /images
mkdir /images

# Set up Hostname and NTP (needs to change for /etc/sysconfig/network)
SIP=(${PRIMARYIP//./ })
HOSTNAME=`echo ${SIP[0]}-${SIP[1]}-${SIP[2]}-${SIP[3]}`
sed -i s/@@HOSTNAME@@/$HOSTNAME/g /etc/hosts
sed -i s/@@HOSTNAME@@/$HOSTNAME/g /etc/sysconfig/network

# Currently using snmpd for host monitoring, let's enable
chkconfig snmpd on

# cleanup
rm -f /tmp/clearwater-post.sh
rm -f /tmp/post.sh

# get out of here
exit 0
