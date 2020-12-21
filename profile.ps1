echo "
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
"

#	Not quite sure what to put here but some ideas would be:
#		- Hostname
#		- IP Address
#		- Current Time

# -------------------------- Window Preferences   -----------------------------

# -------------------------- Alias Configurations -----------------------------
rm alias:\type

$profile =		"$env:userprofile\Documents\WindowsPowershell\profile.ps1"
$default =		"$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\default.json"
$settings = 	"$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$ubuntu = 		""
$programs = 	"$env:localappdata\Programs"

sal vi 		vim
sal type 	gcm
sal unzip 	expand-archive
sal lsblk 	get-disk
sal lspart 	get-partition
sal lsvol 	get-volume
sal make	nmake

sal edg 	'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
sal vm		'C:\Program Files (x86)\VMware\VMware Workstation\VMRun.exe'

sal spotify	"$env:appdata\Spotify\spotify.exe"
sal zoom 	"$env:appdata\Zoom\bin\Zoom.exe"

# -------------------------- Function Definitions -----------------------------
function uedge($val){
	edg --profile-directory="Profile 1" $val
}
function edge($val){
	edg --profile-directory="Default" $val
}
function hist(){
	vi (Get-PSReadLineOption).HistorySavePath
}
function grep(){
	[CmdletBinding()]
	Param([Parameter(ValueFromPipeline)] $obj)
	Param($filter)
	Write-Host (? $obj Name -CMatch '$filter*').Name
}
function touch(){
	if($args[0]){
		if(test-path($args[0])){
			(Get-ChildItem $args[0]).LastWriteTime=Get-Date
		}
		else{
			New-Item $args[0]
		}
	}
}
function mklink ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}
function sudo() {
	if($args[0].length -eq 0 -or $args[0] -eq 'su'){
		start powershell -Verb runas -ArgumentList ('-NoExit', '-Command', "cd `'$(pwd)`'")
	}
	else{
		start powershell -Verb runas -ArgumentList ('-Command', "$args")
	}
}
function bing() {
	$search = $args[0]
	for ($i=1; $i -lt $args.length; $i++) { $search += "+"+$args[$i] }
	$search = "bing.com/search?q=$search"
	echo $search
	edge $search
}
function ubuntu(){
	$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
	vm -T ws start $ubuntu nogui

	while(!($res = (ping -n 1 ubuntu) -match "TTL")) {
		echo "Waiting for bootup..."
	}
	$stopwatch.stop()
	
	$time = $stopwatch.Elapsed.TotalSeconds
	echo "`nUbuntu Startup Time:`t`t$time seconds"

	ssh ubuntu
}
function devenv(){
	pushd 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build'
	cmd /c "vcvarsall.bat $args&set" |
	foreach{
		if ($_ -match "="){
			$v = $_.split("=")
			$key=$v[0]
			$dev=$v[1]
			$path="ENV:\$key"
			if(test-path $path){
				$orig=(get-item -path $path).value;
				if($orig -ne $dev){
					echo "Overwriting old var: $key"
					set-item -force -path $path -value $dev
				}
			}
			else{
				echo "Writing new var: $key"
				set-item -path $path -value $dev
			}
		}
	}
	popd
}
function la{
	ls -Force
}

# readline configuration. Requires version 2.0, if you have 1.2 convert to `Set-PSReadlineOption -TokenType`
Set-PSReadlineOption -Color @{
	"Command" = [ConsoleColor]::White
		"Parameter" = [ConsoleColor]::Green
		"Operator" = [ConsoleColor]::Magenta
		"Variable" = [ConsoleColor]::Green
		"String" = [ConsoleColor]::Yellow
		"Number" = [ConsoleColor]::Blue
		"Type" = [ConsoleColor]::Cyan
		"Comment" = [ConsoleColor]::DarkCyan
}

# colorizing powershell ls
import-module pscolor
$global:PSColor.File.Directory.Color='Blue'
$global:PSColor.File.Executable.Color='Green'
$global:PSColor.File.Compressed.Color='Red'
$global:PSColor.File.Code.Color='Cyan'