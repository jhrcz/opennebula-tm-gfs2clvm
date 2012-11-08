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

SRC=$1
DST=$2
SIZE=$3

if [ -z "${ONE_LOCATION}" ]; then
    TMCOMMON=/usr/lib/one/mads/tm_common.sh
    LVMRC=/etc/one/tm_gfs2clvm/tm_gfs2clvmrc
else
    TMCOMMON=$ONE_LOCATION/lib/mads/tm_common.sh
    LVMRC=$ONE_LOCATION/etc/tm_gfs2clvm/tm_gfs2clvmrc
fi

. $TMCOMMON
. $LVMRC

#source /var/lib/one/remotes/image/fs/fsrc
# include file with VG_NAME definition
# included because of dd optimalizations
ETC_LOCATION=/etc/one
source $ETC_LOCATION/tm_gfs2clvm/tm_gfs2clvmrc

SRC_PATH=`arg_path $SRC`
DST_PATH=`arg_path $DST`

SRC_HOST=`arg_host $SRC`
DST_HOST=`arg_host $DST`

SRC_BASENAME=$( basename "$SRC" )

if [ -z $SIZE ] ; then
    src_volume=lv-oneimg-${SRC_BASENAME}
    hostname=$DST_HOST
    src_volume_size=$(set -x ; ssh $hostname sudo /sbin/lvs --noheadings --units m | grep $src_volume 2>/dev/null | ( read lv vg states size ; echo $size) )
    SIZE=${src_volume_size/M/}
    log "size: $SIZE"
fi

if [ -z $SIZE ] ; then
    SIZE=$DEFAULT_LV_SIZE
fi

LV_NAME=`get_lv_name $DST_PATH`

log "$1 $2"
log "DST: $DST_PATH"

DST_DIR=`dirname $DST_PATH`

log "Creating directory $DST_DIR"
exec_and_log "$SSH $DST_HOST mkdir -p $DST_DIR"

case $SRC in
#------------------------------------------------------------------------------
#Get the image from http repository and dump it to a new LV
#------------------------------------------------------------------------------
http://*)
    log "Creating LV $LV_NAME"
    exec_and_log "$SSH $DST_HOST $SUDO $LVCREATE -L$SIZE -n $LV_NAME $VG_NAME"
    exec_and_log "$SSH $DST_HOST ln -s /dev/$VG_NAME/$LV_NAME $DST_PATH"

    log "Dumping Image into /dev/$VG_NAME/$LV_NAME"
    exec_and_log "eval $SSH $DST_HOST '$WGET $SRC -q -O- | $DD of=/dev/$VG_NAME/$LV_NAME bs=$DD_BS'"
    ;;

#------------------------------------------------------------------------------
#Make a snapshot from the given dev (already in DST_HOST)
#------------------------------------------------------------------------------
*:/dev/*)
    log "Cloning LV $LV_NAME"
    exec_and_log "$SSH $DST_HOST $SUDO $LVCREATE -s -L$SIZE -n $LV_NAME $SRC_PATH"
    exec_and_log "$SSH $DST_HOST ln -s /dev/$VG_NAME/$LV_NAME $DST_PATH"
    exec_and_log "$SSH $DST_HOST chown oneadmin: $DST_PATH"
    ;;

#------------------------------------------------------------------------------
#Get the image from SRC_HOST and dump it to a new LV for iso images
#------------------------------------------------------------------------------
*.iso)
    log "Creating LV $LV_NAME"
    SIZE=640
    exec_and_log "$SSH $DST_HOST $SUDO $LVCREATE -L${SIZE}M -n $LV_NAME $VG_NAME"
    exec_and_log "$SSH $DST_HOST ln -s /dev/$VG_NAME/$LV_NAME $DST_PATH"
    #exec_and_log "$SSH $DST_HOST chown oneadmin: $DST_PATH"

    log "Dumping Image"
    exec_and_log "eval $SSH $DST_HOST $DD if=${SRC_PATH} of=/dev/$VG_NAME/$LV_NAME bs=$DD_BS"
    ;;

#------------------------------------------------------------------------------
#Get the image from SRC_HOST and dump it to a new LV
#------------------------------------------------------------------------------
*)
    log "Creating LV $LV_NAME"
    exec_and_log "$SSH $DST_HOST $SUDO $LVCREATE -L${SIZE}M -n $LV_NAME $VG_NAME"
    exec_and_log "$SSH $DST_HOST ln -s /dev/$VG_NAME/$LV_NAME $DST_PATH"
    #exec_and_log "$SSH $DST_HOST chown oneadmin: $DST_PATH"

    log "Dumping Image"
    exec_and_log "eval $SSH $DST_HOST $DD if=/dev/mapper/${VG_NAME}-lv--oneimg--${SRC_BASENAME} of=/dev/$VG_NAME/$LV_NAME bs=$DD_BS"
    ;;
esac
