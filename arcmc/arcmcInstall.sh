#!/bin/bash
#=============================
#-----------Variables---------
#=============================

function centosArcmc() {

    #This script is to speedup logger prerequisites installation
    #works with Centos/RHEL 7.x and 8.x

    echo -ne "Which is your OS version 7.x or 8.x?  expected options are 7 or 8  "
    read -r sub

    case $sub in
    7)
        if [ "$OS" == "centos" ]; then
            yum install -y unzip fontconfig dejavu-sans-fonts
        else
            subscription-manager register --user serguei.esquivel@microfocus.com --password nGFH58MP8sngaidikTbi98BCa5mbp4
            subscription-manager attach --auto
            yum update -n
            yum install -y unzip fontconfig dejavu-sans-fonts
        fi
        ;;
    8)
        if [ "$OS" == "centos" ]; then
            dnf install -y zip unzip libaio rng-tools ncurses-compat-libs libnsl
            systemctl start rngd.service
            systemctl enable rngd.service
        else
            export {http,https,ftp}_proxy="http://web-proxy.houston.softwaregrp.net:8080"
            subscription-manager register --user serguei.esquivel@microfocus.com --password P8lMz7eKrKf74aS1HAhGXWXU9h30
            subscription-manager attach --auto
            dnf update -n

            dnf install -y zip unzip libaio rng-tools ncurses-compat-libs libnsl
            systemctl start rngd.service
            systemctl enable rngd.service
        fi
        ;;
    *)
        echo "Wrong option."
        exit 1
        ;;
    esac

    hostnamectl set-hostname $hostNName
    
    #adding arcsight user and group
    groupadd arcsight
    groupmod -g 750 arcsight
    useradd -m -g arcsight arcsight
    usermod -u 1500 arcsight

    #adding limits

    echo "* hard nofile 10240" | tee -a /etc/security/limits.conf
    echo "* soft nofile 10240" | tee -a /etc/security/limits.conf

    systemctl stop firewalld
    systemctl disable firewalld
    systemctl mask firewalld

    #creating installers directory
    cd /root
    mkdir arcmcInstall
    cd arcmcInstall

    echo -ne "Wich version of arcmc, option 1 or 2?:  
    #1) Arcmc 3.1
    #2) Arcmc 3.2"

    #por ultimo le damos privilegios de ejecucion y corremos el instalador
    read -r logg
    case $logg in
    1)
        scp $userSSH@10.183.3.95:/opt/installers/arcmc/ArcSight-ArcMC-3.1.0.2266.0.bin .
        chmod +x ArcSight-ArcMC-3.1.0.2266.0.bin
        ./ArcSight-ArcMC-3.1.0.2266.0.bin -i console
        ;;
    2)
        scp $userSSH@10.183.3.95:/opt/installers/arcmc/ArcSight-ArcMC-3.2.0.2321.0.bin .
        chmod +x ArcSight-ArcMC-3.2.0.2321.0.bin
        ./ArcSight-ArcMC-3.2.0.2321.0.bin -i console
        ;;
     *)
        echo "Wrong option."
        exit 1
        ;;
    esac
}

#=============================
#---------Main Program--------
#=============================
#este llama a todos

echo -ne "Please indicate your ssh user, example jsmith:  "
read -r userSSH

echo -ne "Which will be the name of your host? please provide a name:  "
read -r hostNName

centosArcmc

export {http,https,ftp}_proxy=" "
