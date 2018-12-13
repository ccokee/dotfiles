#!/bin/bash


if [ $(sudo mount | grep /net/ST4  | wc -l) == 0 ]
mount -a
else
umount -a -t cifs -l
fi
