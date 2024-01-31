::============================================================
::============================================================
::===Developed by Serguei Esquivel============================
::===Agust 2023===============================================
::===LOGGER INFO==============================================
::============================================================
::============================================================

echo off
setlocal enabledelayedexpansion


FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "logger_wizard.log" -Recurse -File |get-content |select-string 'Arcsight home' | select -first 1"') do (SET installPath=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "arcsight_license" -Recurse -File |get-content | select-string 'Installation Type'"') do (SET installType=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "logger_version.txt" -Recurse -File | get-content"') do (SET loggerVersion=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "system-release" -Recurse -File |get-content"') do (SET osVersion=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "messages" -Recurse -File | get-content | select -first 1 | Foreach {($_ -split ,0)[1]}" ') do (SET Hostname=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "cpuinfo" -Recurse -File |get-content | select-string -pattern 'model name'| select -first 1"') do (SET cpu=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "arcsight_model" -Recurse -File | get-content"') do (SET arcModel=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "arcsight_license" -Recurse -File |get-content |select-string 'appliance.serial-number'"') do (SET arcSerial=%%g)

FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "arcsight_license" -Recurse -File |get-content |select-string -pattern 'customer.name'"') do (SET reguisterON=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "db_dump.sql" -Recurse -File |get-content| select-string -pattern 'database version'"') do (SET postresVersion=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "monit.log" -Recurse -File |get-content| select-string 'arcmcagent..start' | select-string '/opt'|select -first 1"') do (SET arcmcAgent=%%g)
FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "logger_receiver.properties" -Recurse -File |get-content | select-string 'component.count'"') do (SET receiversCount=%%g)

echo.
echo "     ___           _____      __   __  "                                                                             
echo "    / _ | ________/ __(_)__ _/ /  / /_ "                                                                             
echo "   / __ |/ __/ __/\ \/ / _  / _ \/ __/ "                                                                             
echo "  /_/ |_/_/  \__/___/_/\_, /_//_/\__/  "                                                                             
echo "                     /___/             "                                                                            
echo.                                                                                                                
echo  Copyright (c) 2023 Micro Focus or one of its affiliates                                                           
echo  Confidential commercial computer software. Valid license required.
echo. 
echo. 
echo ===========================================================================================================
echo Environmental Details for Logger on:
echo ===========================================================================================================
echo Installation Path or Arcsight Home:        %installPath%
echo Install Type:                              %installType%  
echo Logger Version:                            %loggerVersion%
echo OS Version:                                %osVersion%
echo Hostname:                                  %Hostname%
echo CPU:                                       %cpu%
echo Arcsigh_model:                             %arcModel%
echo Serial Number:                             %arcSerial%
echo Reguistered on name:                       %reguisterON%
echo Postgresql Version:                        %postresVersion%
echo Arcmc Agent Present:                       %arcmcAgent%
echo Number of Receivers:                       %receiversCount%
echo ===========================================================================================================
echo Aditional Data:                                            
echo.                                                                
echo Disk utilization:                          
echo. 
set "output_cnt=0"
for /F "delims=" %%f in ('powershell.exe -Command "Get-ChildItem -Filter "disk_stats.out" -Recurse -File | get-content | select -first 30"') do (
    set /a output_cnt+=1
    set "output[!output_cnt!]=%%f"
)
echo. 
for /L %%n in (1 1 !output_cnt!) DO echo !output[%%n]!
echo. 
echo. 
echo Top 5 process at snaphot:                        
echo.                         
set "output_cnt=0"
for /F "delims=" %%f in ('powershell.exe -Command "Get-ChildItem -Filter "topn5.out" -Recurse -File |get-content | select -first 20"') do (
    set /a output_cnt+=1
    set "output[!output_cnt!]=%%f"
)
echo. 
for /L %%n in (1 1 !output_cnt!) DO echo !output[%%n]!
echo.                                        
echo Netstat of LISTENED state:   
echo.   
set "output_cnt=0"
for /F "delims=" %%f in ('powershell.exe -Command "Get-ChildItem -Filter "netstat_ap.out" -Recurse -File |get-content | select-string 'LISTEN' |select -first 25"
') do (
    set /a output_cnt+=1
    set "output[!output_cnt!]=%%f"
)
echo. 
for /L %%n in (1 1 !output_cnt!) DO echo !output[%%n]!
echo.
echo ===========================================================================================================
