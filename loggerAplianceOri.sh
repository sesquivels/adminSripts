
versionApliance = $(cat opt/arcsight/userdata/logger/user/logger/logger_version.txt)
hostnameApliance =$(tail -n 1 var/log/messages | awk '{print $4}')
osApliance = $(cat etc/*release)
modelApliance = $(cat etc/arcsight_model)


===========================================================
Environmental Details for Logger
===========================================================
Arcsight Product:        Logger
Arcsight Version:        $versionApliance
OS Version:              $osApliance
Hostname:                $hostnameApliance 
Appliance Model:         $modelApliance
Guide used:
===========================================================
