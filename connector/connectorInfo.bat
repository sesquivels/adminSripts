::============================================================
::============================================================
::===Developed by Serguei Esquivel============================
::===Agust 2023===============================================
::===LOGGER INFO==============================================
::============================================================
::============================================================
echo off
setlocal enabledelayedexpansion



FOR /F "delims=" %%g IN ('powershell.exe -Command "Get-ChildItem -Filter "agent.log" -Recurse -File | get-content -Head 3"') do (SET connectorVersion=%%g)

::powershell.exe -Command "Get-ChildItem -Filter "syslog.properties" -Recurse -File | get-content " 
::powershell.exe -Command "Get-ChildItem -Filter "syslog.properties" -Recurse -File | get-content " 
::powershell.exe -Command "Get-ChildItem -Filter "agent.log" -Recurse -File | get-content -Head 3"

::powershell.exe -Command "Get-ChildItem -Filter "agent.properties" -Recurse -File | get-content | findstr "agents\[0\].type=""

::powershell.exe -Command "Get-ChildItem -Filter "agent.properties" -Recurse -File | get-content | findstr ".params"" 
::powershell.exe -Command "Get-ChildItem -Filter "agent.properties" -Recurse -File | get-content | select-string  -Pattern "destination....type""
::powershell.exe -Command "Get-ChildItem -Filter "agent.wrapper.conf" -Recurse -File | get-content | findstr "memory""

::powershell.exe -Command "Get-ChildItem -Filter "agent.properties" -Recurse -File | get-content | findstr "destination.count"" 
echo "   ___           _____      __   __                               "                                                
echo "  / _ | ________/ __(_)__ _/ /  / /_                              "                                                
echo " / __ |/ __/ __/\ \/ / _  / _ \/ __/                              "                                                
echo "/_/ |_/_/  \__/___/_/\_, /_//_/\__/                               "                                                
echo "                                                                  "                                                
echo Copyright (c) 2023 Micro Focus or one of its affiliates                                                           
echo Confidential commercial computer software. Valid license required.

echo ========================================================
echo Connector Environment detail
echo ========================================================
echo.
echo Arcsight Smart Connector Version  and Parser        

set "output_cnt=0"
for /F "delims=" %%f in ('powershell.exe -Command "Get-ChildItem -Filter "agent.log" -Recurse -File | get-content -Head 3"
') do (
    set /a output_cnt+=1
    set "output[!output_cnt!]=%%f"
)
echo. 
for /L %%n in (1 1 !output_cnt!) DO echo              !output[%%n]!
echo.
echo Type:.
echo.
echo Parameters:







