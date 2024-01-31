#============================================================
#============================================================
#===Developed by Serguei Esquivel============================
#===May 2022=================================================
#===LOGGER INFO==============================================
#============================================================
#============================================================

#================================================
#first go for information and assign to variables
#================================================

usualPath=$(pwd)
loggerVersion=$(find . -name logger_version.txt|xargs sed 's/[[:punct:]]$//')
hostName=$(find . -name messages | xargs tail -n 1 |awk '{print $4}')
arcsightModel=$(find . -name arcsight_model| xargs cat)
userName=$(find . -type f -name "logger-*" | xargs grep curr_user | head -n 1 | cut -c 33-)
osVersion=$(find . -name "system-release" |xargs cat)
cpuInfo=$(find . -name cpuinfo | xargs grep "model name" | head -n 1 | cut -c 14-)
ipAddress=$(find . -name messages |xargs grep "Listen normally on 3 eno1"|head -n 1|awk '{print $11}')
customerName=$(find . -name arcsight_license |xargs grep "customer.name" |cut -c 15-)
serialNumber=$(find . -name arcsight_license |xargs grep "appliance.serial-number"| cut -c 25-)
psqlVersion=$(find . -name db_dump.sql | xargs grep "database version" | cut -c 33-)
installPath=$(find . -name arcmc_wizard.log | xargs grep "Arcsight home" | head -n 1| cut -c 22-)
installPath2=$(find . -name logger_init_driver.log | grep current |xargs grep "ARCSIGHT_BIN" | head -n 1| cut -c 14-)
arcmcAgent=$(find . -iname monit.log|xargs grep 'arcmcagent..start'|grep  /opt | tail -n 1 |cut -c 54-)
receiversCount=$(find . -name logger_receiver.properties| xargs grep component.count |cut -c 17-)
diskSpace=$( find . -name disk_stats.out|xargs head -n 35 | sed '1d')
topServer=$(find . -name topn5.out | xargs head -n 20)
netstatListen=$(find . -name netstat_ap.out| xargs grep LISTEN | head -n 25)
InstallType=$(find . -name loggerDeploymentInformation.json | xargs grep "Installation Type" | cut -c 25-)


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

if [  -z "$loggerVersion" ]
	then loggerVersion="No info on the logs, please check with the customer"
fi
if [  -z "$hostName" ]
	then hostName="No info on the logs, please check with the customer"
fi
if [  -z "$arcsightModel" ]
	then installPath="No info on the logs, please check with the customer"
        else appliance="true"
fi
if [  -z "$installPath" ]
	then installPath="No info on the logs, please check with customer"
fi
if [  -z "$osVersion" ]
	then osVersion="No info on the logs, please check with the customer"
fi
if [  -z "$arcsightType" ]
	then arcsightType="No info on the logs, please check with the customer"
fi
if [  -z "$userName" ]
	then userName="No info on the logs, please check with the customer"
fi
if [  -z "$cpuInfo" ]
	then cpuInfo="No info on the logs, please check with the customer"
fi
if [  -z "$ipAddress" ]
	then ipAddress="No info on the logs, please check with the customer"
fi


#================================================
#finally print information
#================================================

echo "==========================================================================================================="
echo "Environmental Details for Logger on: $usualPath"
echo "==========================================================================================================="
echo "Installation Path or Arcsight Home:        $installPath $installPath2"          
echo "Installation User:                         $userName"          
echo "Install Type:                              $InstallType"                  
echo "Logger Version:                            $loggerVersion"          
echo "OS Version:                                $osVersion"
echo "Hostname:                                  $hostName"
echo "CPU:                                       $cpuInfo"
echo "IPADRESS:                                  $ipAddress"
echo "Arcsigh_model:                             $arcsightModel" 
echo "Serial Number:                             $serialNumber"
echo "Reguistered on name:                       $customerName"
echo "Postgresql Version:                        $psqlVersion"
echo "Arcmc Agent Present:                       $arcmcAgent"
echo "Number of Receivers: 	                   $receiversCount"
echo "==========================================================================================================="
echo "Aditional Data:                                            "
echo "                                                           "     
echo "Disk utilization:                          $diskSpace      "
echo "                                                           "     
echo "Top 5 process at snaphot:                  $topServer      "     
echo "                                                           "     
echo "Netstat of LISTENED state:                 $netstatListen  "     
echo "==========================================================================================================="
