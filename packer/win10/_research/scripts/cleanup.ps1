########
# [chef/bento - Public](https://github.com/chef/bento/blob/main/packer_templates/windows/scripts/cleanup.ps1)
Write-Host "Uninstalling Chef..."
$app = Get-WmiObject -Class Win32_Product | Where-Object {
  $_.Name -match "Chef"
}
$app.Uninstall()

Write-Host "Removing leftover Chef files..."
Remove-Item "C:\Opscode\" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Chef\" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Cleaning Temp Files..."
try {
  Takeown /d Y /R /f "C:\Windows\Temp\*"
  Icacls "C:\Windows\Temp\*" /GRANT:r administrators:F /T /c /q  2>&1
  Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
}
catch { }

Write-Host "Optimizing Drive"
Optimize-Volume -DriveLetter C

Write-Host "Wiping empty space on disk..."
$FilePath = "c:\zero.tmp"
$Volume = Get-WmiObject win32_logicaldisk -filter "DeviceID='C:'"
$ArraySize = 64kb
$SpaceToLeave = $Volume.Size * 0.05
$FileSize = $Volume.FreeSpace - $SpacetoLeave
$ZeroArray = new-object byte[]($ArraySize)

$Stream = [io.File]::OpenWrite($FilePath)
try {
  $CurFileSize = 0
  while ($CurFileSize -lt $FileSize) {
    $Stream.Write($ZeroArray, 0, $ZeroArray.Length)
    $CurFileSize += $ZeroArray.Length
  }
}
finally {
  if ($Stream) {
    $Stream.Close()
  }
}

Remove-Item $FilePath
########

########
# [dbond007/Packer - Public](https://github.com/dbond007/Packer/blob/master/windows_base/etc/scripts/99_cleanup.ps1)
Dism /Online /Cleanup-Image /startcomponentcleanup
Dism /Online /Cleanup-Image /CheckHealth
Dism /Online /Cleanup-Image /scanHealth

######if problem#######
DISM /Online /Cleanup-Image /RestoreHealth

#############################clear event logs
Clear-EventLog -LogName (GEt-EventLog -List).log

#####defrag drive
defrag /U /V c:
########

########
# [dbond007 / Packer - Public](https://github.com/dbond007/Packer/blob/master/windows_base/etc/floppy/scripts/post-install.cmd)
# .cmd
REM cmd.exe /c powershell -Command "Install-Software-Chocolatey.ps1"
cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"
C:\Windows\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Disable-Feature-WinRM.ps1
REM No need to RUN
REM %SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f
REM %SystemRoot%\System32\reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f
REM %SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f
REM %SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f

REM Stop network discovery
cmd.exe /c powershell -Command "New-Item -Path HKLM\SYSTEM\CurrentControlSet\Control\Network\ -Name NewNetworkWindowOff -Force"

REM Set Telemetry to security
%SystemRoot%\System32\reg.exe ADD HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\ /v AllowTelemetry /t REG_DWORD /d 0 /f

REM Disable Hibernate and files
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f

REM Stop Server manager starting
%SystemRoot%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\ServerManager\ /v DoNotWACConsoleAtSMLaunch /t REG_DWORD /d 1 /f
%SystemRoot%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\ServerManager\ /v DoNotOpenServerManagerAtLogon /t REG_DWORD /d 1 /f

REM Enable longer directory support
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\ /v LongPathsEnabled /t REG_DWORD /d 1 /f

REM C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Install-Certificates.ps1
REM C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Config-WSUS.ps1
REM C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Remove-Feature-Defender.ps1
REM C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Disable-Network-Netbios.ps1
REM C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Disable-Network-lmhosts.ps1
REM cmd.exe /c a:\Install-Software-RDS-U.cmd
REM cmd.exe /c a:\microsoft-updates.bat
REM cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\win-updates.ps1

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Enable-Feature-WinRM.ps1
########

########
