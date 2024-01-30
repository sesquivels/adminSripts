#!/bin/bash

: '
 Syslog sender script
 Version 1.0

 All this script does is sending, any raw event on events.txt to any destination. 
 It will be reading line by line events.txt and after will ask protocol, ipddress and port.
 
Develop by Serguei Esquivel S.
Jan 2024
'

input=$1
lineCouner=0

function banner() {

   echo "================================================================================================"
   echo "   ___           _____      __   __                               "                                                #
   echo "  / _ | ________/ __(_)__ _/ /  / /_                              "                                                #
   echo " / __ |/ __/ __/\ \/ / _  / _ \/ __/                              "                                                #
   echo "/_/ |_/_/  \__/___/_/\_, /_//_/\__/                               "                                                #
   echo "                    /___/                                         "                                                #
   echo "                                                                  "                                                #
   echo "Copyright (c) 2024 OpenText or one of its affiliates              "                                                #
   echo "Confidential commercial computer software. Valid license required."                              
   echo "================================================================================================"                  #
   echo ""
   echo ""
   echo "Please execute the script followed by events file. For example ./syslogSender.sh events.txt"
   echo "Please create or populate a file called events.txt, with raw events to be sended"
   echo ""
   exit 0
}
function main() {
   if [ -z $input ]; then
      banner
      exit 1
   else 
      sending_events
      exit 0
   fi
}
function sending_events (){
   read -p "Please enter protocol (udp/tcp): " PROTO
   read -p "Please enter IP address: " IP
   read -p "Please enter port: " PORT
   #input="sample.txt"
   while IFS= read -r line
      do
         ((lineCounter++))
         # the next line is for send syslog
         echo "$line" > /dev/$PROTO/$IP/$PORT
      done < "$input"
      echo "This script just sent ${lineCounter} events."
   exit 0
}
#calling main function
main

