@echo off

echo Current user privileges: %userprofile%
echo.
echo Requesting administrative privileges...

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :continue
) else (
    goto :admin
)

:admin
echo.
echo You need to run this batch file as an Administrator.
echo Please grant administrative privileges by selecting "Yes" when prompted.
echo.
powershell -Command "Start-Process '%0' -Verb RunAs"
exit

:continue
echo Administrative privileges confirmed.
echo.

rem *** Registry Backup ***
echo Backing up registry keys... 
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" memory_management_backup.reg
reg export "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" ci_config_backup.reg

echo Registry backup completed.
echo.

rem *** Original Script Logic ***
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v VulnerableDriverBlocklistEnable /t REG_DWORD /d 0x00000000

bcdedit /set hypervisorlaunchtype off

echo.
echo Please Restart Your PC
echo.
pause>nul
exit
