
function centosESM() {

    #This script is to speedup logger prerequisites installation
    #works with Centos/RHEL 7.x and 8.x

    echo -ne "Which is your OS version 7.x or 8.x?"
    read -r sub

    case $sub in
    7)
        yum install -y unzip fontconfig dejavu-sans-fonts
        ;;
    8)
        export {http,https,ftp}_proxy="http://web-proxy.houston.softwaregrp.net:8080"
        subscription-manager register
        subscription-manager attach --auto

        dnf install -y zip unzip libaio rng-tools ncurses-compat-libs libnsl
        systemctl start rngd.service
        systemctl enable rngd.service
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
    #1) Logger 7.5
    #2) Logger 7.6"

    #por ultimo le damos privilegios de ejecucion y corremos el instalador
    read -r logg
    case $logg in
    1)
        scp $userSSH@10.183.3.95:/opt/installers/logger/ArcSight-logger-7.2.0.8372.0.bin .
        chmod +x ArcSight-logger-7.2.0.8372.0.bin
        ./ArcSight-logger-7.2.0.8372.0.bin -i console
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

