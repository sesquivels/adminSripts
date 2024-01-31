#============================================================
#============================================================
#===Developed by Serguei Esquivel============================
#===Sept 2023=================================================
#===CDF INFO==============================================
#============================================================
#============================================================

#================================================
#first go for information and assign to variables
#================================================

usualPath=$(pwd)
loggerVersion=$(find . -type f -name "arcsight-installer_suitefeatures.*" | grep deployment | xargs head -n 10)
hostName=$(find . -name messages | xargs tail -n 1 |awk '{print $4}')
osVersion=$(find . -name "system-release" |xargs cat):
InstallType=$(find . -type f -name "arcsight-installer_suitefeatures.*" | grep deployment | xargs tail -n 20)
kubeSmallgetNode=$(find . -name kube_summary.out | xargs head -n 50)


#================================================
#then must to validate if variables are not null
#================================================

echo "   ___           _____      __   __                               "                                                #
echo "  / _ | ________/ __(_)__ _/ /  / /_                              "                                                #
echo " / __ |/ __/ __/\ \/ / _  / _ \/ __/                              "                                                #
echo "/_/ |_/_/  \__/___/_/\_, /_//_/\__/                               "                                                #
echo "                    /___/                                         "                                                #
echo "                                                                  "                                                #
echo "Copyright (c) 2024 Open Text or one of its affiliates           "                                                #
echo "Confidential commercial computer software. Valid license required."




#================================================
#finally print information
#================================================

echo "==========================================================================================================="
echo "Environmental Details for CDF/OMT on: $usualPath"
echo "==========================================================================================================="
echo "OS Version:                                $osVersion"
echo "Version:                                   $loggerVersion"
echo " "
echo "Install Type:                              $InstallType"
echo " "
echo "Get Nodes:                                 $kubeSmallgetNode"
echo "==========================================================================================================="

