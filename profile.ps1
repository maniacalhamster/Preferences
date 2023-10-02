# My custom Windows Powershell profile
#
# Last updated: April 30, 2021
Write-Host "
               __      __         _                                    
   o O O       \ \    / /  ___   | |   __    ___    _ __     ___ 
  o             \ \/\/ /  / -_)  | |  / _|  / _ \  | '  \   / -_)
 TS__[O]  _____  \_/\_/   \___|  |_|  \__|  \___/  |_|_|_|  \___|
{======|_|'''''|_|'''''|_|'''''|_|'|_|'''|_|'''''|_|'''''|_|'''''|
./o--000' '0---0' '0---0' '0---0' '0' '0-0' '0---0' '0---0' 'o---0'
                           _     _ 
                          / \   | |__   _ _    _ _          O O o
                         | - |  | / /  / _'|  | '_|              o
 _____   _____   _____   |_|_|  |_\_\  \_,_|  |_|_   _____  [O]__ST
|'''''|_|'''''|_|'''''|_|'''''|_|''''|_|'''|_|''''|_|'''''|_|======}
'0---0' '0---0' '0---0' '0---0' '0--0' '0-0' '0--0' '0---0' '000--o\.
";

#   Not quite sure what to put here but some ideas (inspiration from ubuntu's
#   welcome screen):
#       - Hostname
#       - IP Address
#       - Current Time
#       - Weather info (e.g. Invoke-RestMethod "wttr.in")

# -------------------------- Window Preferences   -----------------------------

# -------------------------- Alias Configurations -----------------------------
rm alias:\type

$ubuntu =       "$env:userprofile\Documents\Virtual Machines\UbuntuServer64\UbuntuServer64.vbox"
$hosts =        "\Windows\System32\drivers\etc\hosts"

sal vi      vim
sal type    gcm
sal unzip   Expand-Archive
sal zip     Compress-Archive
sal lsblk   Get-Disk
sal lspart  Get-Partition
sal lsvol   Get-Volume
sal grep    findstr

# -------------------------- Function Definitions -----------------------------

# Simplify the process of navigating through powershell command history
# (reads content of history from file and pipes it to less function - 
# courtesy of git's optional bash features)
function hist(){
    Get-Content (Get-PSReadLineOption).HistorySavePath | less -N
}

# Function to emulate bash's touch command
# -- Creates new file if not exist
# -- Updates write time if file exists
function touch(){
    if($args[0]){
        if(Test-Path($args[0])){
            (Get-ChildItem $args[0]).LastWriteTime=Get-Date
        }
        else{
            New-Item $args[0]
        }
    }
}

# Function to emulate bash's sudo command
# -- If empty args or "su", will open an admin terminal (wt w/ whatever shell is running)
# -- Else, assumes a particular command was issued and runs it w/ admin priv.
# -- -- Both will first change working directory to current directory first
function sudo() {
    [CmdletBinding()]Param()
    $exec = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName;
    $psArgs = "-NoExit -Command Set-Location $pwd`n"
    if($args.length -ne 0 -and ($args.length -ne 1 -or $args[0] -ne 'su')){
        $psArgs += $args
    }
    Write-Host -Verbose "$exec $psArgs"
    Start-Process -Verb runas wt -ArgumentList "$exec $psArgs"
}

# Sets up the MSVC developer environment in current powershell session - just a 
# bunch of temporary env var changes through the vcvarsall.bat file provided w/
# whatever user arguments desired. Additionally notifies user of all changes
# made to path as a result, differentiation between modified and newly created
# env vars
function devenv(){
    pushd 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build';
    if(-not $args){
        $args=$env:PROCESSOR_ARCHITECTURE;
    }
    cmd /c "vcvarsall.bat $args&set" |
        foreach{
            if ($_ -match "Error"){
                break;
            }
            if ($_ -match "="){
                $v = $_.split("=");
                $key=$v[0];
                $dev=$v[1];
                $path="ENV:\$key";
                if(test-path $path){
                    $orig=(get-item -path $path).value;
                    if($orig -ne $dev){
                        echo "Changed: $key";
                        set-item -force -path $path -value $dev;
                    }
                }
                else{
                    echo "New Var: $key";
                    set-item -path $path -value $dev;
                }
            }
            else { 
                echo $_;
            }
        }
    sal make nmake;
    popd;
}

# Shamelessly copied code below
# -----------------------------------------------------------------------------

# readline configuration. Requires version 2.0, if you have 1.2 convert to `Set-PSReadlineOption -TokenType`
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::White;
    "Parameter" = [ConsoleColor]::Green;
    "Operator" = [ConsoleColor]::Magenta;
    "Variable" = [ConsoleColor]::Green;
    "String" = [ConsoleColor]::Yellow;
    "Number" = [ConsoleColor]::Blue;
    "Type" = [ConsoleColor]::Cyan;
    "Comment" = [ConsoleColor]::DarkCyan;
}

# Colorizing powershell ls
Import-Module PSColor
$global:PSColor.File.Directory.Color='Blue'
$global:PSColor.File.Executable.Color='Green'
$global:PSColor.File.Compressed.Color='Red'
$global:PSColor.File.Code.Color='Cyan'

# Function to set machine to a sleep state
# - [System.Windows.Forms.PowerState]::Suspend -> "Suspend"
#       Check the PowerState enumeration for other options
# - param2 $false gives time for apps to prep for sleep
# - param3 $false allows wake events (scheduled or WOL) to wake machine
# 
# - Returns success/failure on wakeup > redirected to null 
function Sleep-Computer() {
    Add-Type -Assembly System.Windows.Forms;
    [System.Windows.Forms.Application]::SetSuspendState("Suspend", $false, $false) | Out-Null;
}

# Function to generate a magic packet to send to Wakeup Over Lan
# - Takes in MAC & IP adresses and port number
# - Byte array casting of 1B of 0xFF (255) values x 6 times followed by
#       the 6B MAC address x 16 times to generate packet
#
# - UDP client created to send the packet to given IP + Port combo, and closed afterwards
#
# - Returns packet length -> redirected to null
function WOL($MAC, $IP, $Port) {
    $MagicPacket = [Byte[]] (,0xFF * 6) + 
        (($MAC -split '[:-]' | ForEach-Object {[Byte] "0x$_"}) * 16);

    $UdpClient = New-Object System.Net.Sockets.UdpClient;

    $UdpClient.Connect(([System.Net.IpAddress]::Parse($IP)), $Port);
    $UdpClient.Send($MagicPacket, $MagicPacket.Length) | Out-Null;
    $UdpClient.Close();
}