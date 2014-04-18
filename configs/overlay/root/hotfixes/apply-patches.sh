#!/bin/sh 
# apply all XenServer patches which have been approved in our manifest

HOTFIXES=/root/hotfixes
HOSTNAME=$(hostname)
HOSTUUID=$(xe host-list name-label=$HOSTNAME --minimal)
while read PATCH
do 
if [ "$(echo "$PATCH" | head -c 1)" != '#' ]
then 
	PATCHNAME=$(echo "$PATCH" | awk -F: '{ split($1,a,"."); printf ("%s\n", a[1]); }')
	echo "Processing $PATCHNAME"
	PATCHUUID=$(xe patch-list name-label=$PATCHNAME hosts=$HOSTUUID --minimal)
	if [ -z "$PATCHUUID" ]
	then
		echo "Patch not yet applied; applying .."
		PATCHUUID=$(xe patch-upload file-name=$HOTFIXES/$PATCH)
		if [ -z "$PATCHUUID" ] #empty uuid means patch uploaded, but not applied to this host
		then
			PATCHUUID=$(xe patch-list name-label=$PATCHNAME --minimal)
		fi
		#apply the patch to *this* host only
		xe patch-apply uuid=$PATCHUUID host-uuid=$HOSTUUID

		# remove the patch files to avoid running out of disk space in the future
		xe patch-clean uuid=$PATCHUUID 
		
		#figure out what the patch needs to be fully applied and then do it
		PATCHACTIVITY=$(xe patch-list name-label=$PATCHNAME params=after-apply-guidance | sed -n 's/.*: \([.]*\)/\1/p')
		if [ "$PATCHACTIVITY" == 'restartXAPI' ]
		then
			xe-toolstack-restart
			# give time for the toolstack to restart before processing any more patches
			sleep 60
		elif [ "$PATCHACTIVITY" == 'restartHost' ]
		then
			# we need to rebot, but we may not be done.
			# need to create a link to our script
			
			# first find out if we're already being run from a reboot
			MYNAME="`basename \"$0\"`"
			if [ "$MYNAME" == 'apply-patches.sh' ]
			then
				# I'm the base path so copy myself to the correct location
				cp "$0" /etc/rc3.d/S99zzzzapplypatches  
			fi
			
			reboot
			exit
		fi
		
	else
		echo "$PATCHNAME already applied"
	fi
	
fi
done < "$HOTFIXES/manifest"

echo "done"
rm -rf $HOTFIXES
rm -f /etc/rc3.d/S99zzzzapplypatches
