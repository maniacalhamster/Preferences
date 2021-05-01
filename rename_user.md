## Process for renaming a user (along with net user name and home directory) for windows

Created for future reference, the process is composed of 3 steps: Rename the 
user account, edit the registry value for home directory, and rename the
home directory itself. All of the below commands will require elevated
privelages to succesfully execute (some might run but with no change otherwise).

---

# Rename the user account

WMIC is deprecated, to be replaced with the Get-CimInstance and related family
of powershell commandlets.   
` WMIC useraccount where name='[query here]' rename '[new name here]' `

Above command has been improved upon with the Get-CimInstance cmdlet as:
` $user = Get-CimInstance Win32_Account | Where-Object Name -Like '[query here]' `   
for retrieval of an account, followed by Invoke-CimMethod for modification:
` Invoke-CimMethod -InputObject $user -MethodName "Rename" -Arguments @{name='[new name here]'} `

This will rename the user account (can verify by running Get-CimInstance w/ new
name or by running `Net User`)
        
# Edit Registry value for home dir

Running `Get-PsDrive` I noticed that alongside Env, Variable, and Function,
that the Hive key current user and local machine dir from the registry were
also available to `Set-Location` to (alias cd).   
Further testing revealed one could `Get-ChildItem` (alias ls) and `Get-ItemProperty`
to move further within the Registry and get registry entry properties, which 
allows one to modify the value for a particular user's home dir:   

```
cd HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\ 
Set-ItemProperty -Path $user.SID -Name ProfileImagePath -Value '[new home dir here]'
```

Quick note that a similar method can be used to modify the path env var from
powershell, ideally testing it out om the temporary env vars before commiting
to registry:

```
$env:path+='[modification to path here]'
Set-ItemProperty -Path HKCU:\Environment -Name Path -Value $env:path
```

For system env path rather than user env path, use path:   
`HKLM:\SOFTWARE\DefaultUserEnvironment`

# Rename home directory

Once you've changed the user's name and the path to home directory in regsitry,
all that's left is to change the home directory itself (usually to reflect on
the name change). Making sure the user logs out if needed, one would simply use
the `Move-Item` commandlet to rename the dir:

` Move-Item \Users\['old home dir name here'] \Users\['new home dire name'] `
