#!/bin/bash

case $1 in
	classic)
		synergy-core --client --name cKlap --daemon --restart 192.168.1.2
	;;
	norestart)
		synergy.core --client --name cKlap --daemon 192.168.1.2
	;;
esac
