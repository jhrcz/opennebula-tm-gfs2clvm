
"gfs2clvm" Transfer Manager Driver for OpenNebula

## DESCRIPTION

The **gfs2clvm** transfer manager driver provides the needed functionality
for running OpenNebula on SAN storage with these premises:

* Virtual machines runing from Clustered LVM (persistnet and nonpersistent running vms, for SOURCE in templates)

* OS template images stored on GFS2 shared storage (bootable isos, for PATH in image template )

* Management node connected to the virtualisation cluster via SSH only

Other nice featurs

* Virtual machines (kvm processes) in the desired configuration are running
  under unprivileged "oneadmin" user

* Logical volumes created for virtual machines owned by "oneadmin" user, so the
  commonly required sudo for "dd" command in suoers is not needed

* copy/snapshot/clone of machine in SUSPENDED state
  by using lvm://{{VMID}}/{{DISKID}} as source

* copy/snapshot/clone of any volume by its ID, useful for persistent OS creation from saved template OS image
  by using vol://{{VOLID}} as source

* when ISO file is named .isox and used for as image, lvm is not used, just symlink to the iso file
  thins enables usecase for installing OS from dvd drive or other media bigger than 640M

Known drawbacks

* Still requires selinux in persmissive mode

* targeted at core IT staff, no acl/permissions when using lvm: and vol: volume sources

## STORAGE LOGIC EXPLAINED

The GFS2 volume in one of the LV is for /var/lib/one on worker nodes,
context.sh contextualisation isos, vm checkpoints, deployment.X and
disk.X symlinks are here. All the files for oned are on the management
node, in /var/lib/one. This storage is NOT shared betwen management
node and worker nodes.

All the images created dynamicaly by opennebula are placed in clvm.

So in the VG, there is

* LV for gfs2

* LVs "lv-one-XXX-X" for nonpresistent, dynamicaly created volumes - these
  volumes are lost when vm is shutdown/deleted/redeployed

* LVs "lv-oneimg-XXXXXXXXXXX for volumes created by opennebula (by saveas,
  cloning, import etc. they replacement of "hash-like" named files in
  /var/lib/one/images)

## INSTALLATION

Files are divided into subdirectories representing destination locations

* etc-one 					/etc/one/ 			(configuration)
* etc-sudoers-d 				/etc/sudoers.d/			(sudo rules)
* etc-udev-rules-d 				/etc/udev/rules.d/		(lvm lv ownership)
* usr-lib-one-tm_commands 			/usr/lib/one/tm_commands/	(tm driver)
* var-lib-one-remotes-image-fs 			/var/lib/one/remotes/image/fs/  (im driver)
* etc-polkit-1-localauthority-50-local.d 	/etc/polkit-1/localauthority/50-local.d/

Other configuration changes

* disabled dynamic ownership

    sed -i -e 's,^#dynamic_ownership = 1,dynamic_ownership = 0,' /etc/libvirt/qemu.conf

* virtual machines running by oneadmin/oneadmin, not root or other user

    sed -i -e 's,^#user = "root",user = "oneadmin",' /etc/libvirt/qemu.conf
    sed -i -e 's,^#group = "root",group = "oneadmin",' /etc/libvirt/qemu.conf


## CURRENT STATE

* instantiate			OK
* resubmit 			OK

* reboot 			OK

* livemigrate 			OK

* suspend 			OK

* migrate 			OK
* stop 				OK
* resume 			OK

* cancel 			OK
* shutdown 			OK
* delete 			OK
* saveas + shutdown 		OK (custom remotes)

* snapshot suspended machine 	OK
* import ttylinux from file 	OK
* create new datablock volume 	OK

* persistence 			OK

* new OS image from other img 	OK

Everything tested on EL6x (as of 2012-03-02, CentOS 6.2)


## ABOUT OPENNEBULA

OpenNebula is an open-source project aimed at building the industry standard
open source cloud computing tool to manage the complexity and heterogeneity of
distributed data center infrastructures.

http://opennebula.org

## AUTHOR

gfs2clvm is composed from original drivers (namely lvm and shared) by
Jan Horacek for Et netera

Contact:
 private: jahor@jhr.cz


## LICENSE

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


