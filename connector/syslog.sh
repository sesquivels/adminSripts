#!/bin/bash
input=$1
lineCouner=0
ip=$2
port=$3
proto=$4

set -x
echo -ne "
====================================================
=================Syslog Sender======================
====================================================

This script will take as first argument protocol,
second argument IP address,third argument port,
and forth argument events

File example: ./script.sh tcp 10.0.0.2 514 test.txt "


if [[ -z "$input" ]]; then
   echo "Please provide the name of the file"
else
if [[ -z "$proto" ]]; then
   echo "Please provide the protocol"
else
if [[ -z "$ip" ]]; then
   echo "Please provide the ip address of syslog destination"
else
if [[ -z "$port" ]]; then
   echo "Please provide the port"
else
   while IFS= read -r line
   do
      #the next line is for send syslog
      echo "$line" > /dev/$proto/$ip/$port
      #just modify ip or port and tcp or udp
      ((lineCounter=lineCounter+1))
   done < "$input"
   echo This script just sent "${lineCounter}" events to "${ip}" on a port "${port}" using "${proto}"
fi

