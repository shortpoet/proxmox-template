# [dbond007 / Packer - Public](https://github.com/dbond007/Packer/blob/master/windows_base/etc/scripts/10_disable_defrag.ps1)
#######disable drive optimisation
If ((Get-ScheduledTask -TaskName 'ScheduledDefrag').State -eq 'Ready') {
  Disable-ScheduledTask -TaskName 'ScheduledDefrag' -TaskPath '\Microsoft\Windows\Defrag'
}
Get-ScheduledTask -TaskName 'ScheduledDefrag'