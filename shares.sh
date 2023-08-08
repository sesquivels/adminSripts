#!/bin/bash

#First rename server
hostnamectl set-hostname share.arcsight.local
#then create shares
mkdir -p /opt/installers/{esm,logger,arcmc,cdf,connectors}
#add grupo
groupadd arcsight
#add users
useradd jcastillo
useradd sesquivels
useradd dramirez
useradd juandi
useradd jotarolaL
useradd allan
useradd pri
useradd aguevara
#add users to group
usermod -a -G arcsight dramirez
usermod -a -G arcsight jcastillo
usermod -a -G arcsight juandi
usermod -a -G arcsight jotarola
usermod -a -G arcsight pri
usermod -a -G arcsight aguevara
usermod -a -G arcsight allan
#modify ownership of shares
chgrp -R arcsight installers/
