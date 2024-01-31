#============================================================
#============================================================
#===Developed by Serguei Esquivel============================
#===July 2023================================================
#===LOGGER INFO==============================================
#============================================================
#============================================================

#================================================
#first go for information and assign to variables
#================================================

usualPath=$(pwd)
loggerVersion=$(find . -name vname.out | xargs cat)
hostName=$(find . -name messages | xargs tail -n 1 |awk '{print $4}')
arcsightModel=$(find . -name arcsight_model| xargs cat)
osVersion=$(find . -name "rhrelease.out" |xargs tail -n 1)
cpuInfo=$(find . -name cpuinfo.out | xargs grep "model name" | head -n 1 | cut -c 14-)
ipAddress=$(find . -name messages |xargs grep "Listen normally on 3 eno1"|head -n 1|awk '{print $11}')
customerName=$(find . -name arcsight_license |xargs grep "customer.name" |cut -c 15-)
serialNumber=$(find . -name arcsight_license |xargs grep "appliance.serial-number"| cut -c 25-)


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
echo "ESM    Version:                            $loggerVersion"
echo "OS Version:                                $osVersion"
echo "Hostname:                                  $hostName"
echo "CPU:                                       $cpuInfo"
echo "IPADRESS:                                  $ipAddress"
echo "Arcsigh_model:                             $arcsightModel"
echo "Serial Number:                             $serialNumber"
echo "Reguistered on name:                       $customerName"
echo "Postgresql Version:                        $psqlVersion"
echo "Arcmc Agent Present:                       $arcmcAgent"
echo "Number of Receivers:                       $receiversCount"
echo "==========================================================================================================="