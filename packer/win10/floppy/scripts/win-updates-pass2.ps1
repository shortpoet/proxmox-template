
Get-WindowsUpdate -Install -AcceptAll -IgnoreUserInput -AutoReboot | Out-File c:\win-updates.log -append
