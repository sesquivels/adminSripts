#!/bin/bash
#Author: Ionut-Daniel Bulai
#Email: ionut-daniel.bulai@microfocus.com
#Special thanks to Mohamed Kurdi who provided the htm format.
#Version: 1.3

#This script is to be used for analysing Arcsight ESM logs.
#ESM is a complex product and when troubleshooting you should look at information holistically.
#It is a prop that saves a lot of time digging through the logs for specific things.

#Do not use while driving!

#Some variable we use and might use later on
IFS=$(echo -en "\n\b")
DATE=$(date +%d-%m-%Y-%H_%M)
SCRIPT_PATH=`SOURCE="${BASH_SOURCE[0]}"; dirname $SOURCE`
OS_KERNEL=`find ./ -name uname.out -print0| xargs -0 cat|cut -d" " -f3 | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\-[0-9]{1,3}'`
OS_VERSION=`grep $OS_KERNEL $SCRIPT_PATH/RHEL_releases.txt | cut -d'	' -f1`
OS_MEMORY_TOT=`find ./ -name server.status.log.[1..4] |xargs grep TotalPhysicalMemorySize|head -1 |awk -F '"' '{printf "%.0f" " MB\n",$2/1024**2}'`
CPUS_NO=`find ./ -name cpuinfo.out -print0|xargs -0 grep --count ^processor`
ESM_VERSION=`find ./ -name server.log |xargs head -n1|sed 's/CODE MAP/ESM version/g'| sed "s/<\|>\|'//g"`
HEAP_SIZE=`find ./ -name server.status.log.1 |xargs grep HeapLimit|tail -n1|cut -d' ' -f8,9|grep -E -o '[^"]*MB'`
INNODB_SIZE=`egrep -rh --include="sw1.txt" "Total memory allocated"|head -n1 | awk -F' ' '{printf $4/1024/1024}'`
REPORT_NAME=Scissorhands_report_$DATE.htm

function sysinfo {
echo "System info:"
echo "$ESM_VERSION"; echo "OS version: $OS_VERSION"; echo "OS memory: $OS_MEMORY_TOT"; echo "CPUs: $CPUS_NO"; echo "Heap size: $HEAP_SIZE"; echo "Innodb buffer size: $INNODB_SIZE MB"
}

function show-diskspace {
echo "Disk usage"
egrep -A100 -hR --include="show-diskspace.out" "Size  Used Avail Use"|grep -v "Size  Used Avail Use"
}

function show_biggest-20-items {
echo "Largest 20 mysql tables"
find ./ -name show_biggest-20-items.out | xargs cat 2> /dev/null
}

function  cache {
echo 'EPS and cache information total'
IFS=$'\n'
for i in $(find ./ -type f -name "server.status.log.*" -printf '%T@ %p\0' | sort -zk 1n |sed 's/^[^ ]* //' | tr '\0' '\n'| xargs egrep -R --include="server.status.log*" "AgentStatuses=")
do
echo $i | awk -F'[][]' '{print $2}'|tr '\r\n' ' '
if [[ -z $(echo $i | sed 's/.*|||//'|sed -e $'s/, /\\\n/g'|grep '^Total'|cut -d "|" -f 10,11,13) ]]; then 
	echo " MISSING MISSING MISSING"
else
	echo $i | sed 's/.*|||//'|sed -e $'s/, /\\\n/g'|grep '^Total'|cut -d "|" -f 10,11,13 | column -s "|" -t
fi
done
}

function server_log {
echo "Server.log messages"
find ./ -name server.log* -not -name "*.idx"| xargs egrep -r '^\[' | grep '\]\[' | awk -F'[][]' '{print $4}'|sort|uniq -c
}

function server_std_log {
echo "Server.std.log messages"
find ./ -name server.std.log* -not -name "*.idx"|xargs cut -d "|" -f1|sort|uniq -c
}

function mysql_error {
echo "Mysql errors"
if  [[ -z $(find ./ -name mysql.log) ]]; then
	echo "There are no logs!"
elif [[ -z $(find ./ -name mysql.log*| xargs grep "mysqld got signal") ]] && [[ -z $(find ./ -name mysql.log*| xargs grep "\[ERROR\]") ]]; then
	echo "No errors found!"
else
	find ./ -name mysql.log*| xargs grep "mysqld got signal" | sed 's/ \+/ /g' |cut -d" " -f4-|sort|uniq -c 2> /dev/null ; find ./ -name mysql.log*| xargs grep "\[ERROR\]" | sed 's/ \+/ /g' |cut -d" " -f3-|sort|uniq -c 2> /dev/null
fi
}

function deadlock {
echo "Session wait deadlocks or foreign key errors"
if  [[ -z $(find ./ -name sw1.txt) ]]; then
	echo "There are no logs!!!"
elif [ $(egrep -r --include="sw*.txt" "DEADLOCK|LATEST FOREIGN KEY ERROR" &>/dev/null; echo $?) -eq "1" ]; then
	echo "No errors found!"
else
	echo "Deadlock or foreign key error detected!"
fi
}

function postgresql {
echo "Postgresql errors"
if  [[ -z $(find ./ -name serverlog) ]]; then
	echo "There are no logs!"
elif [ $(grep -r --include="serverlog*" "ERROR" &>/dev/null; echo $?) -eq "1" ]; then
	echo "No errors found!"
else
	find ./  -name serverlog*| xargs grep "ERROR" 2> /dev/null | sed 's/ \+/ /g' |cut -d" " -f4-|sort|uniq -c #2> /dev/null 
fi
}

function heap {
echo "Count occurrences of heap working set size"
egrep -r --include="server.std.log*" "secs"|awk -F'[K>()]' '{printf "%.0f\n",$3/1024/1024}'|sort -nr -k1|uniq -c|sort -nr -k2
}

function rejected {
echo "Agent requests rejected"
egrep -r --include="server.log*" "agent requests REJECTED"|wc -l
}

function guard {
echo "Guard overflow"
egrep -r --include="server.log*"  "Discarding current  internal data structures to prevent overflow" > /dev/null; 
if [ ${PIPESTATUS[0]} -eq 1 ]; then 
	echo "No guard overflow!"
else
	egrep -r --include="server.log*" "Discarding current  internal data structures to prevent overflow" | sed 's/: Discarding.*//' | sed 's/.*ValueCountsTimeBucket]//' | sort | uniq -c| sort -rn
fi
}

function load {
echo "Could not load cache for active list"
egrep -R  --include="server.log*" "Could not load cache for active list" > /dev/null; 
if [ ${PIPESTATUS[0]} -eq 1 ]; then 
	echo "No errors found!"
else
	grep -R  --include="server.log*" "Could not load cache for active list"|awk -F[/\'] '{print $15,$16,$17}' | sort | uniq -c| sort -rn
fi
}

function over {
echo "SL Resource Access still overflowing after pruning"
egrep -R  --include="server.log*" "still overflowing after pruning, evicting keys" > /dev/null;
if [ ${PIPESTATUS[0]} -eq 1 ]; then 
	echo "No errors found!"
else
	egrep -R  --include="server.log*" "still overflowing after pruning, evicting keys"| cut -d ' ' -f 4-|sort | uniq -c| sort -rn
fi
}

function raw {
echo "Raw chunk size messages"
egrep -R  --include="server.std.log*" "@@@@ raw chunk size" > /dev/null; 
if [ ${PIPESTATUS[0]} -eq 1 ]; then 
	echo "No errors found!"
else
	echo There are `egrep -R  --include="server.std.log*" "@@@@ raw chunk size"| wc -l` occurrences
fi
}

function almonit {
almonit=`grep -r --include="server.status.log.1" "ActiveCacheInformation" |head -n1|sed 's/.*|||//'|sed 's/].*//'|sed -e $'s/,/\\\n/g'|grep -v "Max Temp ID"`; 
echo "Active lists 100% used"
echo "${almonit}"|awk  -F'|' '{if ($6 ~ /100.0%/) print $1;}'
}

function almonit2 {
almonit2=`egrep -R --include="server.status.log.1" "ActiveCacheInformation" |head -n1|sed 's/.*|||//'|sed 's/].*//'|sed -e $'s/,/\\\n/g'|grep -v "Max Temp ID"`;
echo "Active lists hit by 100+ queries or changes"
echo "${almonit2}"|awk  -F'|' '{if ($10 > 100 || $11 > 100) print $1,int($10),int($11);}'
}

function pm {
a=`find ./ -name server.log |xargs head -n1|awk -F" " '{print $3}'| sed "s/<\|>\|'//g"|awk -F"." '{print $2}'`

if [ "$a" -ge "8" ];
	then
	pmmonit=`grep -r --include="server.status.log*" "LoadedRules" |sed 's/.*|||//'|sed 's/\(.*\)]/\1/'|sed 's/, \(\S*==\)/\n\1/g'|grep -v "Aggregation Sets"`;
	echo "High partial matches"
	echo "${pmmonit}"|awk  -F'|' '{if ($7 !~ /N\/A/ && $7 >= 100000) print " ",$2;}'|sort -u
	
	else
	pmmonit=`grep -r --include="server.status.log*" "LoadedRules" |sed 's/.*|||//'|sed 's/\(.*\)]/\1/'|sed 's/, \(\S*==\)/\n\1/g'|grep -v "Aggregation Sets"`;
	echo "High partial matches"
	echo "${pmmonit}"|awk  -F'|' '{if ($8 !~ /N\/A/ && $8 >= 100000) print " ",$2;}' |sort -u
	
fi

}

function report {
echo "Scissorhands report" ; echo "He who does not not work, does not make mistakes!"
}

function agents {
echo "agents.threads.max property"
agents=`grep -r --include="server.status.log.1" "NumberOfAgents" |tail -n1|cut -d'"' -f2`
max_conn=`grep -r --include="server.status.log.1" "MaximumNumberOfOpenConnections"|cut -d"\"" -f2 |sort -n -r|head -n1`
highest_conn=`grep -r --include="server.status.log.1" " NumberOfOpenConnections"|cut -d"\"" -f2 |sort -n -r|head -n1`

echo "Customer configured properties are:"
egrep -rh --include="server.status.log.1" "^agents.threads.max"|tail -n1
egrep -rh --include="server.status.log.1" "^servletcontainer.jetty311.threadpool.maximum"|tail -n1
echo
echo "Customer configured properties based on the agents number, which is $agents, should be:"
agents_threads_max=`echo $agents|awk '{printf "%.0f\n",$1*2*1.3}'`
echo "agents.threads.max=$agents_threads_max"
servletcontainer_jetty311_threadpool_maximum=`echo $agents_threads_max|awk '{printf "%.0f\n",$1*2}'`
echo "servletcontainer.jetty311.threadpool.maximum=$servletcontainer_jetty311_threadpool_maximum"
echo
echo "MaximumNumberOfOpenConnections, since last ESM start, is=$max_conn"
echo "MaximumNumberOfOpenConnections, in current logs, is=$highest_conn"
}

function dbconmanager {
echo "dbconmanager.provider.logger.pool.maxsize property"
echo "Customer configured properties are:"
egrep -rh --include="server.status.log.1" "^dbconmanager.provider.logger.pool.maxsize"|tail -n1
egrep -rh --include="server.status.log.1" "^dbconmanager.provider.logger.event.pool.maxsize"|tail -n1
echo
echo "Customer configured properties should be:"
echo "dbconmanager.provider.logger.pool.maxsize=128"
echo "dbconmanager.provider.logger.event.pool.maxsize=128"
}

function hyperthreading {
echo "Hyper-threading"
siblings=`grep -rh --include="cpuinfo.out" "siblings" |head -n1|cut -d" " -f2`
cpu_cores=`grep -rh --include="cpuinfo.out" "cpu cores" |head -n1|cut -d" " -f3`

if [ "$siblings" == "$cpu_cores" ]
	then
		echo "Hyper-threading is not enabled."
	else
		echo "Hyper-threading is enabled."
fi
}

function fullgc {

a=`find ./ -name server.log |xargs head -n1|cut -d"'" -f2`
case $a in

    6.8.0.1896.0|6.8.0.2015.1|6.8.0.2108.2|6.8.0.2201.3|6.8.0.2285.4|6.9.1.2195.0|6.9.1.2250.1|6.9.1.2310.2|6.9.1.2326.3)
	echo "Full GC"
	printf "Full GC intervals in minutes: " ; egrep -rh --include="server.std.log*" "Full GC"|awk -F"|" '{print $3}'| xargs -i date +%s -d "{}"|sort -r | awk '{printf "%.0f\n",$1/60}'|awk '{if(NR>1){print _n-$1};_n=$1}'|tr '\r\n' ' '
	echo; echo
	printf "Full GC duration in seconds: " ; egrep --no-group-separator -A 1 -rh --include="server.std.log*" ' \| \[Full GC$'|cut -d " " -f16|sed "s/\..*//"| tr '\r\n' ' '
	;;

    6.11.0.2339.0|6.11.0.2385.1)
	echo "Full GC"
	printf "Full GC intervals in minutes: " ; egrep -rh --include="server.std.log*" "Full GC"|awk -F"|" '{print $3}'| xargs -i date +%s -d "{}"|sort -r | awk '{printf "%.0f\n",$1/60}'|awk '{if(NR>1){print _n-$1};_n=$1}'|tr '\r\n' ' '
	echo; echo
	printf "Full GC duration in seconds: " ; egrep --no-group-separator -A 1 -rh --include="server.std.log*" ' \| \[Full GC'|grep -v "Full GC"|cut -d " " -f16|sed "s/\..*//"| tr '\r\n' ' '
	;;
	
esac
}

function innodb {
echo "InnoDB Buffers"
printf "Free buffers:" ; egrep -rh --include="sw*.txt" "Free buffers" |cut -d" " -f9 | tr '\r\n' ' '
echo; echo
printf "Buffer pool hit rate:" ; egrep -rh --include="sw*.txt" "Buffer pool hit rate" |cut -d" " -f5| tr '\r\n' ' '
echo
}

function memredzone {
echo "Memory in red zone"
egrep -R  --include="server.std.log*" "Memory usage in red zone" > /dev/null; 
if [ ${PIPESTATUS[0]} -eq 1 ]; then 
	echo "No errors found!"
else
	echo "Memory in red zone messages found!"
fi
}

function heapsize {
echo "Suggested heap size"
egrep -r --include="server.std.log*" "secs" |awk -F'[K>()]' '{printf "%.0f\n",$3}'|egrep -v "^0" | awk '{sum+=$1} END {printf "%.0f" "GB\n",sum/NR*2/1024/1024}'
}

function slmonit {
slmonit=`grep -r --include="server.status.log.1" "SessionCacheInformation" |head -n1|sed 's/.*|||//'|sed 's/].*//'|sed -e $'s/,/\\\n/g'|grep -v "Main Entry Count"`; 
echo "Sessions lists 100% used"
echo "${slmonit}"|awk  -F'|' '{if ($4 ~ /100.0%/) print $1;}'
}

function slmonit2 {
slmonit2=`egrep -R --include="server.status.log.1" "SessionCacheInformation" |head -n1|sed 's/.*|||//'|sed 's/].*//'|sed -e $'s/,/\\\n/g'|grep -v "Main Entry Count"`;
echo "Session lists hit by 100+ queries or changes"
echo "${slmonit2}"|awk  -F'|' '{if ($5 > 100 || $6 > 100) print $1,int($5),int($6);}'
}

function storagegr {
echo 'CORR-Engine storage groups usage'
grep -r --include="server.status.log.1" "DatabaseFreeSpaceSummary" |head -n1|sed 's/.*|||//'|sed 's/].*//'|sed -e $'s/,/\\\n/g'|grep -v "Tablespace Name" | sed 's/ \+/_/g'|sed 's/^.//g'| cut -d "|" -f 1-4|column -s "|" -t
#grep -r --include="server.status.log.1" "DatabaseFreeSpaceSummary" |head -n1|sed 's/.*|||//'|sed 's/].*//'|sed -e $'s/,/\\\n/g'|grep -v "Tablespace Name" | cut -d "|" -f 1-4|column -s "|" -t
}

function querylong {
echo "Long running mysql queries"
egrep -r --include="show_processlist.out" "*"|awk  '{if ($6 > 3600 ) print $5,$6;}' | grep -v Sleep | wc -l|grep -v "0" > /dev/null;
if [ `echo $?` -eq 1 ]; then
echo 'No long running queries found!'
else
echo `egrep -r --include="show_processlist.out" "*"|awk  '{if ($6 > 1800 ) print $5,$6;}' | grep -v Sleep | wc -l|grep -v "0"` long running queries found!
fi
}

function mysqltune {
echo "my.cnf parameters tuning"

jbs_c=`egrep -rh --include="show_status_variables.out" "join_buffer_size"|awk '{print $2}'`
jbs_o=67108864
tcs_c=`egrep -rh --include="show_status_variables.out" "thread_cache_size"|awk '{print $2}'`
tcs_o=5210
toc_c=`egrep -rh --include="show_status_variables.out" "table_open_cache"|awk '{print $2}'`
toc_o=1024

if [[ -z $(egrep -rh --include="show_status_variables.out" "*") ]];
	then
	echo "The file show_status_variables.out is empty!"
	else

if [ -z "$jbs_c" ];
	then
	echo "Variable join_buffer_size is not set. You need to set it to ${jbs_o}"
elif [ "$jbs_c" -lt "$jbs_o" ];
	then
	echo "Variable join_buffer_size needs to be increased to ${jbs_o}"
fi

if [ -z "$tcs_c" ];
	then
	echo "Variable thread_cache_size is not set. You need to set it to ${tcs_o}"
elif [ "$tcs_c" -lt "$tcs_o" ];
	then
	echo "Variable thread_cache_size needs to be increased to ${tcs_o}"
fi

if [ -z "$toc_c" ];
	then
	echo "Variable table_open_cache is not set. You need to set it to ${toc_o}"
elif [ "$toc_c" -lt "$toc_o" ];
	then
	echo "Variable table_open_cache needs to be increased to ${toc_o}"
fi

fi
}

function throwing {
echo "Throwing out increment"
egrep -hr --include="server.log*"  "Throwing out increment" > /dev/null; 
if [ ${PIPESTATUS[0]} -eq 1 ]; then 
	echo "No errors found!"
else
	echo There are `egrep -hr --include="server.log*" "Throwing out increment" | wc -l` occurrences
fi
}

function dv_value {
echo "DV value cannot be set"
egrep -hr --include="server.log*"  "DV value cannot be set for a security event" > /dev/null; 
if [ ${PIPESTATUS[0]} -eq 1 ]; then 
	echo "No errors found!"
else
	echo There are `egrep -hr --include="server.log*"  "DV value cannot be set for a security event" | wc -l` occurrences
fi
}

function rule_time {
a=`find ./ -name server.log |xargs head -n1|cut -d"'" -f2`
case $a in

    6.8.0.1896.0|6.8.0.2015.1|6.8.0.2108.2|6.8.0.2201.3|6.9.1.2195.0|6.9.1.2250.1|6.9.1.2310.2|6.9.1.2326.3)
	pmmonit=`grep -r --include="server.status.log*" "LoadedRules" |sed 's/.*|||//'|sed 's/\(.*\)]/\1/'|sed 's/, \(\S*==\)/\n\1/g'|grep -v "Aggregation Sets"`;
	echo "High rule time"
	echo "${pmmonit}"|awk  -F'|' '{if ($8 !~ /N\/A/ && $8 >= 30) print " ",$2;}' |sort -u
	;;
	
	6.8.0.2285.4|6.11.0.2339.0)
	pmmonit=`grep -r --include="server.status.log*" "LoadedRules" |sed 's/.*|||//'|sed 's/\(.*\)]/\1/'|sed 's/, \(\S*==\)/\n\1/g'|grep -v "Aggregation Sets"`;
	echo "High rule time"
	echo "${pmmonit}"|awk  -F'|' '{if ($9 !~ /N\/A/ && $9 >= 30) print " ",$2;}' |sort -u
	;;
	
    *)
	echo "High rule time"
	echo "Old ESM version! No high rule time data."
	;;
	
esac
}

function  queues_count {
echo 'Elements in queue count'

IFS=$'\n'

printf "Start-Of-Flow: " ; find ./ -type f -name "server.status.log*" -printf '%T@ %p\0' | sort -zk 1n |sed 's/^[^ ]* //' | tr '\0' '\n'| xargs egrep -A5 -R --include="server.status.log*" "service=BlockingBoundedQueueInputConnector,id=01-Start-Of-Flow" |grep ElementsInQueueCount|cut -d"\"" -f2| tr '\r\n' ' '
echo; echo

printf "Pre-SecurityEventPersistor: " ; find ./ -type f -name "server.status.log*" -printf '%T@ %p\0' | sort -zk 1n |sed 's/^[^ ]* //' | tr '\0' '\n'| xargs egrep -A5 -R --include="server.status.log*" "service=BlockingBoundedQueueInputConnector,id=02-Pre-SecurityEventPersistor" |grep ElementsInQueueCount|cut -d"\"" -f2| tr '\r\n' ' '
echo; echo

printf "Post-SecurityEventPersistor: " ; find ./ -type f -name "server.status.log*" -printf '%T@ %p\0' | sort -zk 1n |sed 's/^[^ ]* //' | tr '\0' '\n'| xargs egrep -A5 -R --include="server.status.log*" "service=BlockingBoundedQueueInputConnector,id=03-Post-SecurityEventPersistor" |grep ElementsInQueueCount|cut -d"\"" -f2| tr '\r\n' ' '
echo; echo

printf "RulesEngineInputBuffer: " ; find ./ -type f -name "server.status.log*" -printf '%T@ %p\0' | sort -zk 1n |sed 's/^[^ ]* //' | tr '\0' '\n'| xargs egrep -A5 -R --include="server.status.log*" "service=Buffer,name=RulesEngineInputBuffer" |grep NumberOfElementsQueued|cut -d"\"" -f2| tr '\r\n' ' '
echo;
}

#array1 is normal text format
array1=(sysinfo mysql_error deadlock postgresql memredzone guard load over raw throwing dv_value almonit almonit2 slmonit slmonit2 pm rule_time hyperthreading agents dbconmanager fullgc innodb querylong heapsize queues_count rejected mysqltune)
#array2 is table format
array2=(show-diskspace show_biggest-20-items cache heap storagegr server_log server_std_log) 

#Explain of each function
desc1="Shows general system information."
desc2="Shows errors from all mysql.log logs and count; includes mysql got signal type errors."
desc3='Checks existence of "deadlock" and "foreign key" errors from sw*.txt logs. Used for advanced troubleshooting of ESM issues.'
desc4="Shows count and postgresql errors from all postgresql logs called serverlog."
desc5='Checks existence of "Memory in red zone" messages across all server.std.log logs.'
desc6='Counts occurrence of "Discarding current internal data structures to prevent overflow." messages across all server.log logs for each Data monitor. For more details please see KB https://softwaresupport.hpe.com/group/softwaresupport/search-result/-/facetsearch/document/KM1262891'
desc7='Checks existence of "Could not load cache for active list" messages across all server.log logs that might lead to manager being unable to start. If found, returns the name of the tableid of the respective active list which needs to be truncated.'
desc8='Checks existence of session list "still overflowing after pruning, evicting keys" messages across all server.log logs that might lead to performance issues or manager being unable to start. If found, returns the count of messages for each session list and the name of the faulty session list. For details please see KB  https://softwaresupport.hpe.com/group/softwaresupport/search-result/-/facetsearch/document/KM00491812'
desc9='Checks existence of "@@@@ raw chunk size" messages across all server.std.log logs that might lead to performance issues. If found, returns the count of messages. For more details please see KB https://softwaresupport.hpe.com/group/softwaresupport/search-result/-/facetsearch/document/KM00634332'
desc10='Checks existence of "Throwing out increment" messages across all server.log logs that might lead to performance issues. If found, returns the count of messages. For more details please see KB https://softwaresupport.hpe.com/group/softwaresupport/search-result/-/facetsearch/document/KM1270622 and https://softwaresupport.hpe.com/group/softwaresupport/search-result/-/facetsearch/document/KM1365989'
desc11='Checks existence of "DV value cannot be set for a security event" messages across all server.log logs that might lead to performance issues. If found, returns the count of messages. For more details please see https://www.protect724.hpe.com/docs/DOC-13392'
desc12='Returns the name of the active lists for which Percent Used is 100%. The source for this information is the first occurence of service ActiveCacheInformation in server.status.log.1 log. If there are no active lists that meet this condition, nothing is returned. For more details please see KB pending.'
desc13='Returns the name of the active lists that are hit by more then 100 queries or changes per second. The source for this information is the first occurence of service ActiveCacheInformation in server.status.log.1 log. If there are no active lists that meet this condition, nothing is returned. For more details please see KB pending.'
desc14='Returns the name of the session lists for which Percent Used is 100%. The source for this information is the first occurence of service SessionCacheInformation in server.status.log.1 log. If there are no session lists that meet this condition, nothing is returned. For more details please see KB pending.'
desc15='Returns the name of the session lists that are hit by more then 100 queries or changes per second. The source for this information is the first occurence of service SessionCacheInformation in server.status.log.1 log. If there are no session lists that meet this condition, nothing is returned. For more details please see KB pending.'
desc16='Returns the name of the rules that have more then 100.000 partial matches. The source for this information is the server.status.log logs. If there are no rules that meet this condition, nothing is returned. For details please see KB  https://softwaresupport.hpe.com/group/softwaresupport/search-result/-/facetsearch/document/KM1271349'
desc17='Returns the name of the rules that have more then 30% Time(%). The source for this information is the server.status.log logs. If there are no rules that meet this condition, nothing is returned. This shows the percentage of processing bandwidth a rule consumes to evaluate events. For details please see KB https://irock.jiveon.com/groups/esm/blog/2017/01/19/esm-rule-partial-matches'
desc18="Checks if Hyper-threading is enabled or not on the machine. If enabled ESM might experience performance issues. The source for this information is the cpuinfo.out file."
desc19='Returns the current agents.threads.max and servletcontainer.jetty311.threadpool.maximum properties from server.status.log.1 log and the suggested values based on the number of existing agents using formula agents.threads.max = (# of agents  x 2 ) x 130%
'
desc20='Returns the current dbconmanager.provider.logger.pool.maxsize and dbconmanager.provider.logger.event.pool.maxsize properties from server.status.log.1 log and the suggested values. For details please see bug NGS-13887'
desc21='Returns the fullgc intervals in minutes from "Full GC" messages across all server.std.log logs sorted from most recent interval to oldest interval. In other words, it shows how often the manager is performing fullgc. Also returns the duration of all the "Full GC" messages across all the server.std.log logs, not sorted.'
desc22='Returns all the "Free buffers" and all the "Buffer pool hit rate" ocurrences from sw.log logs. Used for advanced troubleshooting of ESM issues.'
desc23='Checks existence of mysql queries running more the 30 minutes, and returns the number of such queries. The source of the data is show_processlist.out and it excludes "Sleep" status processes. In case such queris are found the query data in show_processlist.out needs to be investigated.'
desc24='Returns the suggested heap size in GB. The formula used is the average of all the working sets multiplied by 2. The source of this data is all the server.std.log logs.'
desc25='Returns the ElementsInQueueCount in each of the 4 queues Start-Of-Flow, Pre-SecurityEventPersistor, Post-SecurityEventPersistor and RulesEngineInputBuffer, from oldest entry to the newest. By default the configured maximum value for the first 3 queues is 50000. If the values returned are greater then 50000, this denotes there are blockages in those queues. The source for this information is the BlockingBoundedQueueInputConnector and Buffer services in server.status.log logs.'
desc26='Checks existence of "agent requests REJECTED" messages across all server.log logs. If found, returns the count of the messages.'
desc27='Checks the parameters join_buffer_size, thread_cache_size and table_open_cache values in show_status_variables.out file where all the variables computed from mysql properties file should be and returns the optimised values. Parameters that are already optimised are omitted and not returned by the script.'

desc100='Returns the data in show-diskspace.out file, the disk usage.'
desc101='Returns the data in show_biggest-20-items.out file, largest 20 tables in the database.'
desc102='Returns the "Date Time Post-Aggregation-EPS Estimated-Cache-Size Sent-To-Manager-EPS" totals from AgentStateTracker service across all server.status.log logs. Data is sorted by date and time from oldest to newest entries and provides a big picture of how EPS and Cache evolved in time.'
desc103='Returns a count of the rounded to GB values of the heap working set size across all the server.std.log logs.'
desc104='Shows the usage for each of the storage groups. This is where event are stored. As soon as any of the storage groups is full, oldest events are being deleted in order to make way for the new ones. ESM never stops persising events, even if the storage is full.'
desc105='Returns count of each message type in all server.log'
desc106='Returns count of each message type in all server.std.log'

header1='Filesystem	Size	Used	Avail	Use%	Mounted_on'
header2='Database_Tablename	Rows	DATA	idx	total_size	idxfrac'
header3='Date	Time	Post-Aggregation-EPS	Estimated-Cache-Size	Sent-To-Manager-EPS'
header4='Count	GB'
header5='Tablespace_Name	Total_Space(MB)	Free(MB)	%_Free'
header6='Messsage Count'
header7='Messsage Count'

echo "Script is running..."

echo "<!DOCTYPE html>" >> $REPORT_NAME
echo "<html>" >> $REPORT_NAME
echo "" >> $REPORT_NAME
echo "<head>" >> $REPORT_NAME
echo "  <meta name="viewport" content="width=device-width, initial-scale=1">" >> $REPORT_NAME
echo "  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">" >> $REPORT_NAME
echo "  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>" >> $REPORT_NAME
echo "  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>" >> $REPORT_NAME
echo "  <meta charset="UTF-8">" >> $REPORT_NAME
echo "</head>" >> $REPORT_NAME
echo "" >> $REPORT_NAME
echo "<style>" >> $REPORT_NAME
echo "table {font-family: arial, sans-serif;border-collapse: collapse;font-size:	15px;}" >> $REPORT_NAME
echo "body {font-family: Calibri, Tahoma, sans-serif!important;margin:15px 0 0 15px;font-size: 16px;color:#000!important;}" >> $REPORT_NAME
echo "h1 {font-size: 34px;color: #3385ff;margin: 0;font-weight:bold!important;padding-bottom:20px;}" >> $REPORT_NAME
echo "h2 {color: #3385ff;font-weight:bold!important;font-weight:bold!important;}" >> $REPORT_NAME
echo "h3 {background-color: #3385ff; color:#fff;max-width: 900px;padding: 3px 10px;margin: 0;font-weight:bold!important;font-size: 19px!important;}" >> $REPORT_NAME
echo "h4 {margin:0;padding:0;}" >> $REPORT_NAME
echo "body {max-width:900px;}" >> $REPORT_NAME
echo "p {font-size: 16px;}" >> $REPORT_NAME
echo "li{list-style:square;}" >> $REPORT_NAME
echo "tr:nth-child(even) {background-color: #dddddd;}" >> $REPORT_NAME
echo "td, th {border: 1px solid #dddddd;text-align: center;padding: 5px;}" >> $REPORT_NAME
echo ".description {font-size: 20px;}" >> $REPORT_NAME
echo ".warning {#FFF6BF 5px 5px; padding: 1em; border: 2px solid #FFD324; color: #817134;display: inline-block}" >> $REPORT_NAME
echo ".console {font-family:Courier;color: #CCCCCC; background: #000000; border: 3px double #CCCCCC; padding: 10px;}" >> $REPORT_NAME
echo ".icons {color: #fff; background-color: rgba(0,179,136,.8); padding: 6px;margin-right: 5px; border-radius: 25px;}" >> $REPORT_NAME
echo ".float {float:left;margin: 15px 20px 30px 10px;display: inline-block; clear:both!important;}" >> $REPORT_NAME
echo ".infowrap {color: #fff; background-color: #3385ff;padding: 15px; max-width: 850px;}" >> $REPORT_NAME
echo ".related {background-color: #f2f2f2; padding: 10px 35px; display: inline-block;}" >> $REPORT_NAME
echo ".green {color: #3385ff;}" >> $REPORT_NAME
echo ".highlight {background-color: #f2f2f2;padding: 1px 10px;border: 1px solid #ccc; font-family:Courier}" >> $REPORT_NAME
echo ".grey {color: #555;}" >> $REPORT_NAME
echo ".link {background-color: #f6f6f6; color:#111;font-family:Courier; padding:2px 4px;;font-size:90%;}" >> $REPORT_NAME
echo "::selection { color: #fff; background: #3385ff;} " >> $REPORT_NAME
echo ".block {border: 1px solid #ccc; margin-bottom:30px;padding: 20px;}" >> $REPORT_NAME
echo ".explainbtn { float: right;margin:2px;}" >> $REPORT_NAME
echo ".explaincontent {padding-left:10px; color: #006598;font-style: italic;}" >> $REPORT_NAME
echo "</style>" >> $REPORT_NAME

echo "<body>">> $REPORT_NAME
echo "<h1>Scissorhands report</h1>">> $REPORT_NAME
echo "<p>He who does not work, does not make mistakes!</p>">>$REPORT_NAME

#initialize counter for first array descriptions
dcount=1

for i in "${array1[@]}"
do
$i|head -n1|sed 's/^/<h3>/'|sed 's/$/<\/h3>/' >> $REPORT_NAME

echo "<!--explanation-->" >> $REPORT_NAME
printf '<button type="button" class="btn btn-default btn explainbtn" data-toggle="collapse" data-target="#' >> $REPORT_NAME
printf desc${dcount} >> $REPORT_NAME
echo "\">Explain</button>" >> $REPORT_NAME
printf '<div id="' >> $REPORT_NAME
printf desc${dcount} >> $REPORT_NAME
echo '" class="collapse explaincontent">' >> $REPORT_NAME
TMP="desc$dcount"
echo ${!TMP}  >> $REPORT_NAME
echo '</div>' >> $REPORT_NAME
echo "<!--/explanation-->" >> $REPORT_NAME

echo '<div class="block">' >>$REPORT_NAME
$i|awk 'NR>=2'|sed 's/ \+/ /g' | sed 's/\s/ /g'|sed -e 's/^[ \t]*//'|sed 's/$/<\/br>/' >> $REPORT_NAME
echo '</div>'>> $REPORT_NAME
let "dcount++"
done

#initialize counter for second array descriptions and headers
dcount=100
hcount=1

for i in "${array2[@]}"
do
$i|head -n1|sed 's/^/<h3>/'|sed 's/$/<\/h3>/'>> $REPORT_NAME

echo "<!--explanation-->" >> $REPORT_NAME
printf '<button type="button" class="btn btn-default btn explainbtn" data-toggle="collapse" data-target="#' >> $REPORT_NAME
printf desc${dcount} >> $REPORT_NAME
echo "\">Explain</button>" >> $REPORT_NAME
printf '<div id="' >> $REPORT_NAME
printf desc${dcount} >> $REPORT_NAME
echo '" class="collapse explaincontent">' >> $REPORT_NAME
dcount_tmp="desc$dcount"
echo ${!dcount_tmp} >> $REPORT_NAME
echo '</div>' >> $REPORT_NAME
echo "<!--/explanation-->" >> $REPORT_NAME

echo '<div class="block">'>> $REPORT_NAME
echo '<table>' >> $REPORT_NAME
hcount_tmp="header$hcount"
echo ${!hcount_tmp}| sed 's/ \+/ /g' | sed 's/\s/ /g'|sed -e 's/^[ \t]*//' | sed 's/^/<tr><th>/' | sed 's/$/<\/tr><\/th>/' | sed 's/\s/<\/td><th>/g' >> $REPORT_NAME
$i|awk 'NR>=2'|sed 's/ \+/ /g' | sed 's/\s/ /g'|sed -e 's/^[ \t]*//' | sed 's/^/<tr><td>/' | sed 's/$/<\/tr><\/td>/' | sed 's/\s/<\/td><td>/g' >> $REPORT_NAME
echo '</table>' >> $REPORT_NAME
echo '</div>'>> $REPORT_NAME
let "dcount++"
let "hcount++"
done

echo "</html>">> $REPORT_NAME

echo "Script execution finished."
