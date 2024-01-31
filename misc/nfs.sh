#!/bin/bash


function exports() {
    echo "/opt/arcsight-nfs/itom-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/db-single-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/db-backup-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/itom-logging-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/arcsight-volume dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    exportfs -ra
}

function packages() {
    yum install -y bind-utils nfs-utils
}

function services() {
    systemctl enable rpcbind
    systemctl start rpcbind
    systemctl enable nfs-server
    systemctl start nfs-server
    systemctl disable firewalld
    systemctl stop firewalld
}

function directories() {
    mkdir -p /opt/arcsight-nfs/itom-vol /opt/arcsight-nfs/db-single-vol /opt/arcsight-nfs/db-backup-vol /opt/arcsight-nfs/itom-logging-vol /opt/arcsight-nfs/arcsight-volume/opt/arcsight-nfs/itom-vol/opt/arcsight-nfs/db-single-vol/opt/arcsight-nfs/db-backup-vol/opt/arcsight-nfs/itom-logging-vol/opt/arcsight-nfs/arcsight-volume
    chown -R 1999:1999 /opt/arcsight-nfs
}



packages
directories
exportfs
services


