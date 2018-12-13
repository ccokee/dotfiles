#!/bin/bash

cblue="^fg(#92bbd0)"
cgray="^fg(#999999)"
cwhite="^fg(#ffffff)"
cnormal="^fg(#dddddd)"
cred="^fg(#bc4547)"
cyellow="^fg(#a88c29)"
cgreen="^fg(#00aa6c)"
cpurple="^fg(#9542f4)"
cnormal="^fg(#dddddd)"


if [ $(mount | grep /net/ST1 | wc -l) -gt 0  ]; then
 ST1="${cgreen}"
else
 ST1="${cred}"
fi
if [ $(mount | grep /net/ST2 | wc -l) -gt 0  ]; then
 ST2="${cgreen}"
else
 ST2="${cred}"
fi
if [ $(mount | grep /net/ST3 | wc -l) -gt 0  ]; then
 ST3="${cgreen}"
else
 ST3="${cred}"
fi
if [ $(mount | grep /net/ST4 | wc -l) -gt 0  ]; then
 ST4="${cgreen}"
else
 ST4="${cred}"
fi
if [ $(mount | grep /net/USB | wc -l) -gt 0  ]; then
 USB="${cgreen}" 
else
 USB="${cred}"
fi
if [ -b /dev/sdb  ]; then
 if [ $(mount | grep /dev/sdb | wc -l) -gt 0  ]; then
  SDB="${cgreen}"
 else
  SDB="${cgray}"
 fi
else
SDB="${cred}"
fi

storagestatus="$ST1 $ST2 $ST3 $ST4 $USB $SDB"

echo "$storagestatus" > /tmp/status_storage
