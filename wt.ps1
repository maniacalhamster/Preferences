Write-Host " - Making sure wt.exe runs as expected before making a shortcut to it!"
Start-Process -WindowStyle hidden "$env:localappdata\Microsoft\WindowsApps\wt.exe"

Write-Host "Creating an instance of WScript.Shell object, referred to as 'shell'"
$shell = New-Object -ComObject WScript.Shell

Write-Host " - Creating a link with that shell instance using .CreateShortcut method"
Write-Host "`twt.lnk will be created under the programs folder of the start menu "
$wt = $shell.CreateShortcut("$env:appdata\Microsoft\Windows\Start Menu\Programs\wt.lnk")

Write-Host " - Setting an appropriate description for the shortcut"
$wt.Description='Shortcut for opening Windows Terminal (and applying hotkey!)'

Write-Host " - Setting up hotkey for wt (alt+ctrl+t, just like linux terminal shortcut)"
$wt.HotKey='Alt+Ctrl+t'

Write-Host " - Filtering through list of running processes for wt to get path"
Write-Host "`tthis is used to set the IconLocation of the link"
$wt.IconLocation=(Get-Process | Where-Object ProcessName -Like 'windowsterminal')[0].Path

Write-Host " - Setting targetPath to point to the wt.exe this link will run"
$wt.TargetPath="$env:localappdata\Microsoft\WindowsApps\wt.exe"

Write-Host " - Setting the workingdirectory (not necesarry) to the location of the wt.exe"
$wt.WorkingDirectory="$env:localappdata\Microsoft\WindowsApps"

Write-Host "`nConfirm wt shortcut properties to be correct:"
Write-Host "---------------------------------------------"
Write-Host $wt
$inp = Read-Host

Write-Host "Saving wt obj to effectively write the changes in"
$wt.Save()

Write-Host "User will need to restart for shortcut hotkey to be effective"
Write-Host "`nRestart Now? (Y)/N"

$inp = Read-Host
if ($inp -ne "N" -and $inp -ne "n"){
	shutdown -l
}
