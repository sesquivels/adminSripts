

# This is so bash does not overwrite an existing file
# set -C
# LOGDIR=thdiag-`hostname`-`date +%Y-%m-%d-%H-%M-%S`
# HOSTNAME=`hostname`
# HOSTIP=`host $HOSTNAME | awk '/has address/ {print $4}'`
# TH_NAMESPACE=`kubectl get namespaces | grep arcsight-installer | awk '{print $1}'`
# AI_NAMESPACE=`kubectl get namespaces | grep investigate | awk '{print $1}'`
# taken from th-diag to set variables /INST2103

# 01 Check that nodes were all booted near each other
(echo $'UPTIME:';uptime) > /tmp/$HOSTNAME.info.txt

# 02 Query OS release text and currently booted kernel and install date. 
(echo $'\n\nCHECKING KERNEL:\n'; uname -a; rpm -qi basesystem; cat /etc/os-release|head -1) >> /tmp/$HOSTNAME.info.txt
# reference versions: https://access.redhat.com/articles/3078 

# 03 Checking if minimal OS installation
(echo $'\n\nCHECKING PACKAGE COUNT:'; echo $'If ~300 = minimal install, if > 1000 is full'; rpm -qa|wc -l) >> /tmp/$HOSTNAME.info.txt

# 04 Verify if this is hardware of VM
(echo $'\n\nCHECKING IF VIRTUALIZED:\n'; journalctl| grep 'smpboot: Allowing\|Hypervisor\|Memory\|DMI' -m 5) >> /tmp/$HOSTNAME.info.txt

# 05 Checking Memory and CPU
(echo $'\n\nCHECKING MEMORY AND CPU\n:'; free ; lscpu) >> /tmp/$HOSTNAME.info.txt

# 06 Verify partitions are sized properly
(echo $'\n\nCHECKING PARTITIONS:\n'; df -hT) >> /tmp/$HOSTNAME.info.txt

# 07 Verify not using swap or other deviant mount points for /dev/mapper
(echo $'\n\nCHECKING SWAP AND MOUNT POINTS:\n'; cat /etc/fstab) >> /tmp/$HOSTNAME.info.txt

# 08 Verify hosts file not using IPv6
(echo $'\n\nCHECKING HOSTS NOT USING IPV6 AND OTHER ENTRIES:\n'; cat /etc/hosts) >> /tmp/$HOSTNAME.info.txt

# 09 Query packages and removed ones: Remove libraries that will prevent Ingress from starting
(echo $'\n\nCHECKING IF MISSING PACKAGES:\nNote java not needed on workers\n'; rpm -q container-selinux socat java-1.8.0-openjdk device-mapper-libs libgcrypt libseccomp libtool-ltdl net-tools nfs-utils rpcbind systemd-libs httpd-tools unzip conntrack-tools curl lvm2  | grep "not installed") >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING REMOVED PACKAGES per pg24 CDF guide:\n'; rpm -q rsh rsh-server vsftpd) >> /tmp/$HOSTNAME.info.txt

# 10 Check if the PasswordAuthentication is set to yes
(echo $'\n\nCHECKING PASSWORDAUTHENTICATION:\n'; grep -i PasswordAuthentication /etc/ssh/sshd_config) >> /tmp/$HOSTNAME.info.txt

# 11 check System Parameters for Network Bridging PG21 CDF GUIDE looking for misspelling such as hyphen left out
(echo $'\n\nCHECKING sysctl SYSTEM PARAMETERS - ALL NODES output:\n'; cat /etc/sysctl.conf | sed /#/d) >> /tmp/$HOSTNAME.info.txt

# 12 checking bridge netfilter - https://wiki.archlinux.org/index.php/Network_bridge
(echo $'\n\nVERIFY br_netfilter MODULE:\n'; lsmod |grep br_netfilter) >> /tmp/$HOSTNAME.info.txt

# 13 sestatus for selinux - DONT DISABLE, MAYBE USE PERMISSIVE MODE TO TROUBLESHOOT
(echo $'\n\nCHECKING SESTATUS:\n'; sestatus) >> /tmp/$HOSTNAME.info.txt 

# 14 Gotta know the default gateway
(echo $'\n\nCHECKING DEFAULT GATEWAY:\n'; ip route) >> /tmp/$HOSTNAME.info.txt

# 15 And the DNS
(echo $'\n\nCHECKING DNS:\n'; cat /etc/resolv.conf) >> /tmp/$HOSTNAME.info.txt

# 16 The IPs ... expecting extra VIP to show on active master node
(echo $'\n\nCHECKING IPs:\n'; ip a) >> /tmp/$HOSTNAME.info.txt

# 17 check Environment for any outstanding changes like selinux, proxy, zsh, current user, shell level, other, etc. 
(echo $'\n\nCHECKING ENVIRONMENT VARIABLES:\n'; env | sed /COLOR/d) >> /tmp/$HOSTNAME.info.txt

# 18 The firewall
(echo $'\n\nCHECKING FIREWALL:\n'; firewall-cmd --list-all 2>>/tmp/$HOSTNAME.info.txt;iptables -S | grep -- '-P INPUT' ) >> /tmp/$HOSTNAME.info.txt

# 19 Make sure no other ArcSight processes are running on these nodes
(echo $'\n\nCHECKING FOR OTHER ARCSIGHT PRODUCTS INSTALLED:\n'; ps -aux | grep arc | cut -b 1-100) >> /tmp/$HOSTNAME.info.txt

# 20 See which version NFS this host / client is using
(echo $'\n\nCHECKING NFS version used to connect to NFS server and statistics:\n'; nfsstat) >> /tmp/$HOSTNAME.info.txt

# 21 Chronyc 
(echo $'\n\nCHECKING CHRONYC SYNC:\n'; timedatectl) >> /tmp/$HOSTNAME.info.txt

# 22 Check Broker ID  
(echo $'\n\nCHECKING BROKERID:\n'; cat /opt/arcsight/k8s-hostpath-volume/th/kafka/meta.properties) >> /tmp/$HOSTNAME.info.txt

# 23 TH version
(echo $'\n\nCHECKING TH Version:\n'; curl --noproxy 127.0.0.1 -k -u "admin:atlas" https://127.0.0.1:38080/cluster/version ) >> /tmp/$HOSTNAME.info.txt

# 24 Check if license is activated
(echo $'\n\nCHECKING If License Activated:\n'; cat /opt/arcsight/k8s-hostpath-volume/th/autopass/license.log)  >> /tmp/$HOSTNAME.info.txt

# 25 Check if known Memory Issues or limits reached  
(echo $'\n\nCHECKING If any known memory issues causing reboot:\n'; journalctl --list-boots) >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING If any instances of sacrifice child:\n'; journalctl | grep 'sacrifice child' |wc) >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING If any instances of out of memory:\n'; journalctl | grep 'out of memory' |wc) >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING If anything is modifying running tuning variables:\n'; ) >> /tmp/$HOSTNAME.info.txt


# 26 Pg 22 of CDF 2020_05 guide step 3
(echo $'\n\nCHECKING nmodprobe and netfilter runlevel startup:\n'; ls -l /etc/rc.d/rc.local; cat /etc/rc.d/rc.local) >> /tmp/$HOSTNAME.info.txt

# 27 Checking if Cordoned or Ready nodes
(echo $'\n\nCHECKING kubernetes NODES:\n'; kubectl get nodes --all-namespaces -o wide) >> /tmp/$HOSTNAME.info.txt

# 28 Checking PODS
(echo $'\n\nCHECKING kubernetes NODES:\n'; kubectl get pods --all-namespaces -o wide) >> /tmp/$HOSTNAME.info.txt

# 29 Checking 

# NFS SECTION
# This section will pick up NFS information if this script is run on a linux CLI NFS server.
# this will simply error out on other hosts
(echo $'\n\nCHECKING NFS server info - expect errors if run on other nodes:\n'; cat /etc/exports;showmount -e) >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING NFS FOLDER STRUCTURE:') >> /tmp/$HOSTNAME.info.txt
(echo $' - There should not be a result here on TH nodes -\n'; find /opt/arcsight/nfs/ -maxdepth 2 -exec ls -l {} \;) >> /tmp/$HOSTNAME.info.txt
# (find /opt/arcsight/nfs/ -maxdepth 2 -exec ls -l {} \;) >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING NFS FOLDER SIZES\n'; du -mchd 2 /opt/arcsight/nfs/) >> /tmp/$HOSTNAME.info.txt
# (du -mchd 2 /opt/arcsight/nfs/) >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING NFS VERSION AND STATS\n'; nfsstat -v; rpm -q rpcbind) >> /tmp/$HOSTNAME.info.txt
# (nfsstat -v; rpm -q rpcbind) >> /tmp/$HOSTNAME.info.txt
(echo $'\n\nCHECKING TOP OUTPUT - waiting 2 iterations:\n'; top -b -n 2) >> /tmp/$HOSTNAME.info.txt


echo 
echo ---
echo Please upload the log file created at /tmp/$HOSTNAME.info.txt
echo ---
echo 

# END

## each of the cmds written as individual subshells for bash so we don't artifact the current users shell.
## not in a "for" or "while" loop or function just for ease of reading by any customers weary of what this does. 
## david.mix@microfocus.com originated 10/2019.  Continuing to update. 
## 
# Change Log 3/2020 
# Changed name to PostCheck from PreFlight to avoid confusion due to TH / CDF already has a procedure called preflight. 
# Added NFS server commands into this one script so there are not two procedures and running extra data collection commands has no negative effect.
# Added client side NFS command to tell which version is being used to connect. 
# Numbered commands for clarity
# Added check in step 9 for packages that CDF guide says should be removed 
# Added timedatectl output
# Added redirect firewall disabled error 2> command to step 18
# Added more output info in NFS section 
# Checks for TH version and Broker ID and redirect firewall error in #18
# 20200323 - added RHEL kernel version URL
# 202005 Added checks for TH 3.2 RPMs container-selinux and socat
# 20200701  checking license log and journalctl boots
# 20200710  adding echo note for customer to upload the output
# 20200813  adding journalctl commands and long list and cat for rc.local to confirm.  Started to work on making this passwordless ssh compatible. 
# 20200813  changed #4 dmesg to journalctl due to centos 8 has removed dmesg
# 20200827	adding kubernets commands #26 and #27
# 20210311  adding install date to output #2 with basesystem query
# 20210408	adding TOP batch output re-iterates twice to eliminate spike during first run (focus on 2nd output). 

