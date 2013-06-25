Reference Installer of Citrix XenServer 6.2 (Clearwater)

http://www.xenserver.org/

This installer can be used to set up a server with support for XenAPI support in Openstack.

Drop the contents of the XenServer 6.2 Clearwater ISO into citrix/clearwater.  You can place the latest 
hotfixes (XS62E001.xsupdate) updates into configs/overlay/root/hotfixes and they will be installed on
firstboot automatically.  See the configs/overlay/etc/firstboot.d/95-openstack-firstboot for more info
on what starts at boot.

Direct download here:

http://downloadns.citrix.com.edgesuite.net/7281/XenServer-6.2.0-install-cd.iso
