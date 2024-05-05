
#============================================================
#============================================================
#===Developed by Serguei Esquivel============================
#===May 2024=================================================
#============================================================
#============================================================


#================================================
#first go for information and assign to variables
#================================================

usualPath=$(pwd)
connVersion=$(find . -name loadbalancer.log |xargs head -n 1 | sed 's/<CODE MAP://' | sed 's/>//' | sed "s/'//g")
osName=$(find . -type f -name "*SmartConnector_Load_Balancer_Install*" | xargs grep os.name | awk '{print $3" " $4" " $5" " $6}')
userName=$(find . -type f -name "*SmartConnector_Load_Balancer_Install*" | xargs grep user.name | awk '{print $3}')
installPath=$(find . -type f -name "*SmartConnector_Load_Balancer_Install*" | xargs grep USER_INSTALL_DIR | sed 's/USER_INSTALL_DIR=//')
vipAddress=$(find . -type f -name lbConfig.xml | xargs grep "vipAddress" | sed 's/<memberHosts//g' | sed 's/>//g'| sed 's/"//g')
vipMembers=$(find . -name lbConfig.xml | xargs grep "vipBindCommand=" | sed 's/<memberHost/member/g' |sed 's/name//g' | cut -c -73 |sed 's/"//g')
initMemory=$(find . -type f -name lb.wrapper.conf |xargs grep initmemory | sed 's/wrapper.java.initmemory=//')
maxMemory=$(find . -type f -name lb.wrapper.conf |xargs grep maxmemory | sed 's/wrapper.java.maxmemory=//')
routingInfo=$(find . -name lbConfig.xml | xargs grep "routingRule" |sed 's/<//g' |sed 's/>//g' |sed 's/"//g' |sed 's/routingRules//g' |sed 's/\///g')
sourceInfo=$(find . -name lbConfig.xml | xargs grep "source name"|sed 's/<source name/source/g' |sed 's/\/>//g' |sed 's/"//g')
destinationPool=$(find . -name lbConfig.xml | xargs grep -i "destinationpool" | grep -v routingRule | sed 's/<//g' |sed 's/>//g' | sed 's/\///g' | sed 's/destinationPools//g' |sed 's/destinationPool name/pool/g' |sed 's/"//g')
destinationDetail=$(find . -name lbConfig.xml | xargs grep "destination name" | sed 's/<//g' | sed 's/>//g' | sed 's/"//g')
#================================================
#then must to validate if variables are not null
#================================================

echo "   ___           _____      __   __                               "                                                #
echo "  / _ | ________/ __(_)__ _/ /  / /_                              "                                                #
echo " / __ |/ __/ __/\ \/ / _  / _ \/ __/                              "                                                #
echo "/_/ |_/_/  \__/___/_/\_, /_//_/\__/                               "                                                #
echo "                    /___/                                         "                                                #
echo "                                                                  "                                                #
echo "Copyright (c) 2024 Open Text or one of its affiliates             "                                                #
echo "Confidential commercial computer software. Valid license required."


#================================================
#finally print information
#================================================


echo "==========================================================================================================="
echo "Environmental Details for Connector on: $usualPath"
echo "==========================================================================================================="
echo "Installation Path:      $installPath"
echo "Installation User:      $userName"
echo "Arcsight Version:      $connVersion"
echo "OS Version:             $osName"
echo "VIP Address:       $vipAddress"
echo "VIP Members:    $vipMembers"
echo "InitMemory:             $initMemory MB"
echo "MaxMemory:              $maxMemory MB"
echo "==========================================================================================================="
echo "Source Info:        $sourceInfo"
echo "Destination Pool:   $destinationPool"
echo "Destination Detail: $destinationDetail"
echo "Routing Rules:       $routingInfo"
echo "Arcsight User Guide used:"
echo "==========================================================================================================="
