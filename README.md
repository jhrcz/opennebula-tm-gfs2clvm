
"gfs2clvm" Transfer Manager Driver for OpenNebula

**WARNING** this is WORK in PROGRESS tree preparing for next OpenNebula release

## DESCRIPTION

The **gfs2clvm** transfer manager driver provides the needed functionality
for running OpenNebula on SAN storage with these premises:

* Virtual machines runing from Clustered LVM (persistnet and nonpersistent running vms, for SOURCE in templates)

* OS template images stored on GFS2 shared storage (bootable isos, for PATH in image template )

* Management node connected to the virtualisation cluster via SSH only

## ABOUT OPENNEBULA

OpenNebula is an open-source project aimed at building the industry standard
open source cloud computing tool to manage the complexity and heterogeneity of
distributed data center infrastructures.

http://opennebula.org

## AUTHOR

gfs2clvm is composed from original drivers by Jan Horacek for Et netera

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


