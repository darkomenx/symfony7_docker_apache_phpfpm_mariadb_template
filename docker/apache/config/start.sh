#!/bin/bash

/usr/sbin/service apache2 start
/usr/sbin/service ssh start
tail -f /dev/null
