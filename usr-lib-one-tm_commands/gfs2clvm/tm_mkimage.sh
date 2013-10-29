#!/bin/bash

# -------------------------------------------------------------------------- #
# Copyright 2002-2012, OpenNebula Project Leads (OpenNebula.org)             #
#                                                                            #
# Licensed under the Apache License, Version 2.0 (the "License"); you may    #
# not use this file except in compliance with the License. You may obtain    #
# a copy of the License at                                                   #
#                                                                            #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
#                                                                            #
# Unless required by applicable law or agreed to in writing, software        #
# distributed under the License is distributed on an "AS IS" BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
# See the License for the specific language governing permissions and        #
# limitations under the License.                                             #
#--------------------------------------------------------------------------- #

if [ -z "${ONE_LOCATION}" ]; then
    TMCOMMON=/usr/lib/one/mads/tm_common.sh
    LVMRC=/etc/one/tm_gfs2clvm/tm_gfs2clvmrc
else
    TMCOMMON=$ONE_LOCATION/lib/mads/tm_common.sh
    LVMRC=$ONE_LOCATION/etc/tm_gfs2clvm/tm_gfs2clvmrc
fi

. $TMCOMMON
. $LVMRC

SIZE=$1
FSTYPE=$2
DST=$3

DST_PATH=`arg_path $DST`
DST_HOST=`arg_host $DST`
DST_DIR=`dirname $DST_PATH`

MKFS_CMD=`mkfs_command $DST_PATH $FSTYPE`

LV_NAME=`get_lv_name $DST_PATH`

log "Creating LV $LV_NAME"
exec_and_log "$SSH $DST_HOST $SUDO $LVCREATE -L${SIZE}M -n $LV_NAME $VG_NAME"
sleep 3
exec_and_log "$SSH $DST_HOST mkdir -p $DST_DIR"
exec_and_log "$SSH $DST_HOST ln -s /dev/$VG_NAME/$LV_NAME $DST_PATH"
#exec_and_log "$SSH $DST_HOST chown oneadmin: $DST_PATH"

log "Dumping Image"
#exec_and_log "eval $SSH $DST_HOST $DD if=/dev/zero of=/dev/$VG_NAME/$LV_NAME bs=64k"

# mkfs is not in PATH, so override with full path specified
exec_and_log "$SSH $DST_HOST ${MKFS_CMD/mkfs//sbin/mkfs}"

