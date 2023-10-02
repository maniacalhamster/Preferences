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

$profile =      "$env:userprofile\Documents\Powershell\profile.ps1"
$ubuntu =       "$env:userprofile\Documents\Virtual Machines\UbuntuServer64\UbuntuServer64.vbox"
$repos=         "$env:userprofile\GIT"
$default =      "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\default.json"
$settings =     "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$programs =     "$env:localappdata\Programs"
$hosts =        "\Windows\System32\drivers\etc\hosts"

sal vi      vim
sal type    gcm
sal unzip   expand-archive
sal lsblk   get-disk
sal lspart  get-partition
sal lsvol   get-volume
sal grep    findstr

sal edg     'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'

sal spotify     "$env:appdata\Spotify\spotify.exe"
sal zoom        "$env:appdata\Zoom\bin\Zoom.exe"
sal sumatraPDF  sumatraPDF-3.2-64

# -------------------------- Function Definitions -----------------------------

# Quick way to launch Microsoft's edge browser (specifying between personal and
# university profiles)
function uedge($val){
    edg --profile-directory="Profile 1" $val
}
function edge($val){
    edg --profile-directory="Default" $val
}

# Simplify the process of navigating through powershell command history
# (reads content of history from file and pipes it to less function - 
# courtesy of git's optional bash features)
function hist(){
    Get-Content (Get-PSReadLineOption).HistorySavePath | less -N
}

#                      ## grep machine broke ##
#
# [Used to be a function to emulate bash's grep function but it's faulty]
####function grep(){
####    begin{
####        $filter = $args[0];
####    }
####    process{
####        $input | findstr /RX $filter
####    }
####}

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

function la{
    ls -Force;
}

# Function to emulate bash's sudo command
# -- If run as is or with 'su', will open up an admin terminal session
# -- Else, assumes a particular command was issued and runs it w/ admin priv.
# -- -- Both will first change working directory to current directory first
function sudo() {
    $exec = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName;
    if($args[0].length -eq 0 -or $args[0] -eq 'su'){
        Start-Process -WorkingDirectory . -Verb runas $exec -ArgumentList '-NoExit'
    }
    else{
        Start-Process -WorkingDirectory . -Verb runas $exec -ArgumentList '-Command', $args
    }
}

# Simplify the process of making a search using the bing search engine on an 
# Edge browser
function bing() {
    $search = $args[0]
    for ($i=1; $i -lt $args.length; $i++) { $search += "+"+$args[$i] }
    $search = "bing.com/search?q=$search"
    Write-Host $search
    edge $search
}

# Automate the task of running a virtual machine in the background and ssh-ing
# into it once it has booted up (notifying user of bootup in process and timing
# the whole process as well). Specifically run an ubuntu 20.04 x64 server on 
# oracle's virtualbox 
function ubuntu(){
    $time = 0;

    if(!(Get-Process | ? Name -Match "VBoxHeadless" | ? CommandLine -Match "VBoxHeadless.exe`" -s .*UbuntuServer64.vbox")){
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew();
        Start-Process VBoxHeadless -WindowStyle Hidden -ArgumentList("-s `"$ubuntu`"");

        Write-Host -NoNewline "`nWaiting for bootup";
        while(!(Test-Connection ubuntu -TimeoutSeconds 1.5 -Count 1 -Quiet)) {
            Write-Host -NoNewline "...";
        }
        Write-Host;
        $stopwatch.stop();
        $time = $stopwatch.Elapsed.TotalSeconds;
    }

    Write-Host "`nUbuntu Startup Time:`t$time seconds";
    if(!($time)){
        Write-Host "(was probably already up)`n";
    }
    else{
        Write-Host;
    }

    ssh ubuntu;
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

# Runs opens up vscode to path specified in the background (either file or folder)
function vscode($path) {
    (& "$env:localappdata\Programs\Microsoft VS Code\Code.exe" $path)&;
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
