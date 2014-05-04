Reference Installer of Citrix XenServer 6.2 (Clearwater)

http://www.xenserver.org/

This installer can be used to set up a server with support for XenAPI support in Openstack.

#### Getting Started

1. `wget https://github.com/bloodhero/xs-clearwater-openstack/archive/master.zip`
2. `unzip master.zip`
3. `mv xs-clearwater-openstack /path/to/wwwroot/xenserver/`
4. `mount -o loop /path/to/XenServer6.2.iso /path/to/wwwroot/xenserver/citrix/clearwater`
5. Download the hotfixes file to `/path/to/xenserver/configs/overlay/root/hotfixes` and add the hotfixes name to manifest file. they will be installed on
firstboot automatically. 
6. See the configs/overlay/etc/firstboot.d/95-openstack-firstboot for more info
on what starts at boot.

Change any references to http://kickstart/... to the your appropriate URL.

Direct download here:

http://downloadns.citrix.com.edgesuite.net/akdlm/7281/XenServer-6.2.0-install-cd.iso
