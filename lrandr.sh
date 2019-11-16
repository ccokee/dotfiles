#!/bin/bash

case $1 in:
	l)
		/home/coke/.screenlayout/left.sh
	;;
	r)
		/home/coke/.screenlayout/right.sh
	;;
	t)
		/home/coke/.screenlayout/top.sh
	;;
	b)
		/home/coke/.screenlayout/bottom.sh
	;;
	*)
		/home/coke/.screenlayout/default.sh
	;;
esac
