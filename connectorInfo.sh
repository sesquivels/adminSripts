
#============================================================
#============================================================
#===Developed by Serguei Esquivel============================
#===May 2022=================================================
#============================================================
#============================================================


#================================================
#first go for information and assign to variables
#================================================

usualPath=$(pwd)
connVersion=$(find . -name agent.log |xargs head -n 1 | sed 's/<CODE MAP://' | sed 's/>//' | sed "s/'//g")
connParser=$(find . -name agent.log |xargs head -n 3 |tail -n 1 | sed 's/[aA-zZ]//g' | sed 's/>//' |sed 's/<//'|sed 's/://g' | sed "s/'//g")
osName=$(find . -type f -name "*ArcSight_SmartConnector_Install*" | xargs grep os.name | awk '{print $3" " $4" " $5" " $6}')
userName=$(find . -type f -name "*ArcSight_SmartConnector_Install*" | xargs grep user.name | awk '{print $3}')
installPath=$(find . -type f -name "*ArcSight_SmartConnector_Install*" | xargs grep USER_INSTALL_DIR | sed 's/USER_INSTALL_DIR=//')
initMemory=$(find . -type f -name agent.wrapper.conf |xargs grep initmemory | sed 's/wrapper.java.initmemory=//')
maxMemory=$(find . -type f -name agent.wrapper.conf |xargs grep maxmemory | sed 's/wrapper.java.maxmemory=//')
arcsightType=$(find . -type f -name agent.properties | xargs grep "agents....type"  |sed '2d' | cut -c 16-)
destinationCount=$(find . -type f -name agent.properties | xargs grep "destination.count" | cut -c 29-)
destinationType=$(find . -type f -name agent.properties | xargs grep "destination....type" | cut -c 31-)
destinationInfo=$(find . -type f -name agent.properties | xargs grep "destination....params" | cut -c 35- | sed 's/\t/\n/g')
sourceSyslogType=$(find . -type f -name syslog.properties | xargs sed 's/,/\n \t/g' | sed '/^#/d')
portConnector=$(find . -type f -name agent.properties | xargs grep "agents....port"  |sed '2d' | cut -c 16-)
protocolConnector=$(find . -type f -name agent.properties | xargs grep "agents....protocol"  |sed '2d' | cut -c 20-)



#================================================
#then must to validate if variables are not null
#================================================

echo "   ___           _____      __   __                               "                                                #
echo "  / _ | ________/ __(_)__ _/ /  / /_                              "                                                #
echo " / __ |/ __/ __/\ \/ / _  / _ \/ __/                              "                                                #
echo "/_/ |_/_/  \__/___/_/\_, /_//_/\__/                               "                                                #
echo "                    /___/                                         "                                                #
echo "                                                                  "                                                #
echo "Copyright (c) 2021 Micro Focus or one of its affiliates           "                                                #
echo "Confidential commercial computer software. Valid license required."

if [  -z "$osName" ]
        then osName="No info on the logs, ask customer"
fi
if [  -z "$userName" ]
        then userName="No info on the logs, ask customer"
fi
if [  -z "$installPath" ]
        then installPath="No info on the logs, ask customer"
fi
if [  -z "$initMemory" ]
        then initMemory="No info on the logs, ask customer"
fi
if [  -z "$maxMemory" ]
        then maxMemory="No info on the logs, ask customer"
fi
if [  -z "$arcsightType" ]
        then arcsightType="No info on the logs, ask customer"
fi
if [  -z "$sourceSyslogType" ]
        then sourceSyslogType="This connector is not a syslog or, not sufficient info on the logs"
fi

#================================================
#finally print information
#================================================


echo "==========================================================================================================="
echo "Environmental Details for Connector on: $usualPath"
echo "==========================================================================================================="
echo "Installation Path:      $installPath"
echo "Installation User:      $userName"
echo "Arcsight Version:      $connVersion"
echo "Arcsight Parser:     $connParser"
echo "OS Version:             $osName"
echo "Source Vendor:          Please Confirm"
echo "Source Version:         Please Confirm"
echo "Syslog source:          $sourceSyslogType"
echo "Arcsight type:          $arcsightType | $portConnector | $protocolConnector"
echo "InitMemory:             $initMemory MB"
echo "MaxMemory:                $maxMemory MB"
echo "Destination Count       $destinationCount"
echo "Destination Type        $destinationType"
echo "Destination Info        $destinationInfo"
echo "Arcsight User Guide used:"
#echo "==========================================================================================================="
#echo "Plan:                                                                                                      "
#echo "==========================================================================================================="
#echo "Stage1:                                                                                                    "
#echo "Stage2:                                                                                                    "
#echo "Stage3:                                                                                                    "
#echo "Stage4:                                                                                                    "
#echo "==========================================================================================================="
