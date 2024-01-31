#!/bin/bash 

echo "options are: popos,parrot,fedora,centos7,centos8,rhel7,rhel8,kali: $1"

# here is good place to chech if $1 is empty and genarate 2 options one if that is truego to option if that is false ask again

OSTIPE=$1

if [ $OSTIPE == "popos" ]
then
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common
    sudo chown -R sesquivels:root /opt /mnt /installers
    mkdir -p /mnt/{general,sesquivels}
    echo "192.168.100.235:/zroot/general /mnt/general nfs defaults 0 0" |sudo tee -a /etc/fstab
    echo "192.168.100.235:/zroot/sesquivels /mnt/sesquivels nfs defaults 0 0" |sudo tee -a /etc/fstab
    sudo mount -a
    mkdir -p /installers/startupConfigs
    cp /mnt/general/configs/setupInicial.tar /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupInicial.tar
    ./ohmyzsh.sh
    ./colorscripts.sh
fi

if [ $OSTIPE == "parrot" ]
then
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common firmware-realtek nvidia-driver nvidia-cuda-toolkit 
    sudo chown -R sesquivels:root /opt /mnt /installers
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
    mkdir -p /mnt/{general,sesquivels}
    echo "192.168.100.235:/zroot/general /mnt/general nfs defaults 0 0" |sudo tee -a /etc/fstab
    echo "192.168.100.235:/zroot/sesquivels /mnt/sesquivels nfs defaults 0 0" |sudo tee -a /etc/fstab
    sudo mount -a
    mkdir -p /installers/startupConfigs
    cp /mnt/general/configs/setupInicial.tar /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupInicial.tar
    ./ohmyzsh.sh
    ./colorscripts.sh
fi


if [ $OSTIPE == "kali" ]
then
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common  nvidia-driver nvidia-cuda-toolkit 
    sudo chown -R sesquivels:root /opt /mnt /installers
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
    mkdir -p /mnt/{general,sesquivels}
    echo "192.168.100.235:/zroot/general /mnt/general nfs defaults 0 0" |sudo tee -a /etc/fstab
    echo "192.168.100.235:/zroot/sesquivels /mnt/sesquivels nfs defaults 0 0" |sudo tee -a /etc/fstab
    sudo mount -a
    mkdir -p /installers/startupConfigs
    cp /mnt/general/configs/setupInicial.tar /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupInicial.tar
    ./ohmyzsh.sh
    ./colorscripts.sh
    cd ~/Documents
    ln /mnt/general/unidocs .
    ln /mnt/sesquivels/Estudios .
    ln /mnt/sesquivels/Dev .
fi
if [ $OSTIPE == "fedora" ]
then
	sudo dnf update -y
	sudo dnf install curl git neovim mc kitty zsh cifs-utils nfs-utils net-tools
	sudo chown -R sesquivels:root /opt /mnt/ /installers
        wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
        mkdir -p /mnt/{general,sesquivels}
        echo "192.168.100.235:/zroot/general /mnt/general nfs defaults 0 0" |sudo tee -a /etc/fstab
        echo "192.168.100.235:/zroot/sesquivels /mnt/sesquivels nfs defaults 0 0" |sudo tee -a /etc/fstab
        sudo mount -a
	mkdir -p /installers/startupConfigs
	cp /mnt/general/configs/startUPS/setupRHEL.tar.gz /installers/startupConfigs
	cd /installers/startupConfigs
	tar xvf setupRHEL.tar.gz
	cd firstSetupRHEL
	sudo dnf install ./google-chrome-stable_current_x86_64.rpm
	
	./ohmyzsh.sh
        ./colorscripts.sh
	kitty
	./restoreSettings.sh 
fi
if [ $OSTIPE == "centos7" ]
then
fi
if [ $OSTIPE == "centos8" ]
then
fi
if [ $OSTIPE == "rhel7" ]
then
fi
if [ $OSTIPE == "rhel8" ]
then
fi
