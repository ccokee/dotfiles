#!/bin/bash

case $1 in
cKtv)
 case $2 in
  new)

  ;;
  current)
  xtigervncviewer -SecurityTypes VncAuth -passwd /home/coke/.vnc/passwd :1
  ;;
 esac
;;
cKvpn)

;;
cKdesk)

;;
*)
;;
esac
