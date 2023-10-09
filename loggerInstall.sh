#!/bin/bash
#=============================
#-----------Variables---------
#=============================

function centosLogger() {

    echo -ne "Please indicate your ssh user, example jsmith:  "
    read -r userSSH

    echo -ne "Which will be the name of your host? please provide a name:  "
    read -r hostNName

    echo -ne "Which is your OS version 7.x or 8.x?"
    read -r sub

    export {http,https,ftp}_proxy="http://web-proxy.houston.softwaregrp.net:8080"

    hostnamectl set-hostname $hostNName

   case $sub in
    7)
        if [ "$OS" == "centos" ]; then
            yum install -y unzip fontconfig dejavu-sans-fonts
        else
            subscription-manager register --user serguei.esquivel@microfocus.com --password nGFH58MP8sngaidikTbi98BCa5mbp4
            subscription-manager attach --auto
            yum update -y
            yum install -y unzip fontconfig dejavu-sans-fonts
        fi
        ;;
    8)
        if [ "$OS" == "centos" ]; then
            dnf install -y zip unzip libaio rng-tools ncurses-compat-libs libnsl
            systemctl start rngd.service
            systemctl enable rngd.service
        else
            
            subscription-manager register --user serguei.esquivel@microfocus.com --password P8lMz7eKrKf74aS1HAhGXWXU9h30
            subscription-manager attach --auto
            dnf update -y

            dnf install -y zip unzip libaio rng-tools ncurses-compat-libs libnsl
            systemctl start rngd.service
            systemctl enable rngd.service
        fi
        ;;
    *)
    esac

    hostnamectl set-hostname $hostNName
    
    #adding arcsight user and group
    groupadd arcsight
    groupmod -g 750 arcsight
    useradd -m -g arcsight arcsight
    usermod -u 1500 arcsight
    groupadd –g 750 arcsight
    useradd –m –g arcsight –u 1500 arcsight

    #adding limits
    echo "* soft nproc 10240" | tee -a /etc/security/limits.d/20-nproc.conf
    echo "* hard nproc 10240" | tee -a /etc/security/limits.d/20-nproc.conf
    echo "* soft nofile 65536" | tee -a /etc/security/limits.d/20-nproc.conf
    echo "* hard nofile 65536" | tee -a /etc/security/limits.d/20-nproc.conf

    sed -i 's/#RemoveIPC=no/RemoveIPC=no/' /etc/systemd/logind.conf
    systemctl restart systemd-logind.service

    echo "net.ipv4.tcp_fin_timeout = 30" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_time = 60" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_intvl = 2" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_probes = 2" | tee -a /etc/sysctl.conf

    sysctl -p

    systemctl stop firewalld
    systemctl disable firewalld
    systemctl mask firewalld

    #creating installers directory
    cd /root
    mkdir loggerInstall
    cd loggerInstall

    echo -ne "Wich version of logger, option 1 or 2?:  
    #1) Logger 7.2
    #2) Logger 7.3"

    #por ultimo le damos privilegios de ejecucion y corremos el instalador
    read -r logg
    case $logg in
    1)
        scp $userSSH@10.183.3.95:/opt/installers/logger/ArcSight-logger-7.2.0.8372.0.bin .
        chmod +x ArcSight-logger-7.2.0.8372.0.bin
        ./ArcSight-logger-7.2.0.8372.0.bin -i console
        ;;
    2)
        scp $userSSH@10.183.3.95:/opt/installers/logger/ArcSight-logger-7.3.0.8422.0.bin .
        chmod +x ArcSight-logger-7.3.0.8422.0.bin
        ./ArcSight-logger-7.3.0.8422.0.bin
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

centosLogger

export {http,https,ftp}_proxy=" "
