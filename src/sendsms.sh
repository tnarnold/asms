#!/usr/bin/env bash
SMSCMD=`which gsmsendsms`
$SMSCMD -d /dev/ttyACM0  -b 19200 $1 "$2"