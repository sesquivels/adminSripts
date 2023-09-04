#!/bin/bash

OS=$(cat /etc/*release | grep ID |head -n 1| awk -F '=' ' {print $2}' |sed 's/"//g')

function state() {
    echo -ne "
On which state of installation are you?
1) Initial pre reboot stage
2) Post reboot Installation
3) First run
0) Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        preInstall
        ;;
    2)
        postReboot
        ;;
    3)
        firstRun
        ;;
    0)
        echo "Bye bye."
        exit 0
        ;;
    *)
        echo "Wrong option."
        exit 1
        ;;
    esac
}


function preInstall() {

    #This script is to speedup esm prerequisites installation
    #works with Centos/RHEL 7.x and 8.x

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

    #creating installers directory
    cd /root
    mkdir esmInstall
    cd esmInstall

    echo -ne "Wich version of ESM?
    #1) ESM 7.5
    #2) ESM 7.6"

    #por ultimo le damos privilegios de ejecucion y corremos el instalador
    read -r logg
    case $logg in
    1)
        scp $userSSH@10.183.3.95:/opt/installers/esm/ArcSightESMSuite-7.5.0.2516.0.tar .
        tar xvf ArcSightESMSuite-7.5.0.2516.0.tar
        cd Tools
        ./prepare_system.sh
        ;;
    2)
        scp $userSSH@10.183.3.95:/opt/installers/esm/ArcSightESMSuite-7.6.0.2523.0.tar .
        tar xvf ArcSightESMSuite-7.6.0.2523.0.tar
        cd Tools
        ./prepare_system.sh
        ;;
     *)
        echo "Wrong option."
        exit 1
        ;;
    esac
}

function postReboot() {

    #being root we will copy binary and script

    chown arcsight:arcsight /root/esmInstall/ArcSightESMSuite.bin
    chown arcsight:arcsight /root/installESM.sh
    cp /root/installESM.sh /home/arcsight
    cp /root/esmInstall/ArcSightESMSuite.bin /home/arcsight/
    cd /home/arcsight
    chmod +x ArcSightESMSuite.bin
    su -c "./ArcSightESMSuite.bin -i console" arcsight

}


#=============================
#---------Main Program--------
#=============================
#este llama a todos


state
