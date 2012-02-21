
"gfs2clvm" Transfer Manager Driver for OpenNebula

## DESCRIPTION

The **gfs2clvm** transfer manager driver provides the needed functionality
for running OpenNebula on SAN storage with these premises:

* Virtual machines runing from Clustered LVM

* OS templates and images stored on GFS2 shared storage

* Management node connected to the virtualisation cluster via SSH only

Other nice featurs

* Virtual machines (kvm processes) in the desired configuration are running
  under unprivileged "oneadmin" user

* Logical volumes created for virtual machines owned by "oneadmin" user, so the
  commonly required sudo for "dd" command in suoers is not needed

## INSTALLATION

Files are divided into subdirectories representing destination locations

  * etc-one 					/etc/one/ 			(configuration)
  * etc-sudoers-d 				/etc/sudoers.d/			(sudo rules)
  * etc-udev-rules-d 				/etc/udev/rules.d/		(lvm lv ownership)
  * usr-lib-one-tm_commands 			/usr/lib/one/tm_commands/	(tm driver)
  * etc-polkit-1-localauthority-50-local.d 	/etc/polkit-1/localauthority/50-local.d/

## CURRENT STATE

* instantiate		OK
* resubmit 		OK

* reboot 		OK
* stop 			FAIL (inherited from original drivers)
* livemigrate 		OK
* migrate 		FAIL (inherited from original drivers, stop is not working)

* suspend 		OK
* resume 		OK

* cancel 		OK
* shutdown 		OK
* delete 		OK
* saveas + shutdown 	FAIL (storage is not available on the management node)

Everything tested on EL6x (as of 2012-02-20, CentOS 6.2)


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


