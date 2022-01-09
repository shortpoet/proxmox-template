# [StefanScherer / packer-windows - Public](https://github.com/StefanScherer/packer-windows/blob/main/scripts/disable-screensaver.ps1)

Write-Output "Disabling Screensaver"
Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0 -Type DWord
& powercfg -x -monitor-timeout-ac 0
& powercfg -x -monitor-timeout-dc 0