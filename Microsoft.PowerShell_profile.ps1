echo "
__      __          _                                               ___     _                             
\ \    / / ___     | |     __      ___    _ __     ___      o O O  /   \   | |__   __ _      _ _     o O O
 \ \/\/ / / -_)    | |    / _|    / _ \  | '  \   / -_)    o       | - |   | / /  / _' |    | '_|   o     
  \_/\_/  \___|   _|_|_   \__|_   \___/  |_|_|_|  \___|   TS__[O]  |_|_|   |_\_\  \__,_|   _|_|_   TS__[O]
_|'''''|_|'''''|_|'''''|_|'''''|_|'''''|_|'''''|_|'''''| {======|_|'''''|_|'''''|_|'''''|_|'''''| {======|
''-0-0-'''-0-0-'''-0-0-'''-0-0-'''-0-0-'''-0-0-'''-0-0-'./o--000'''-0-0-'''-0-0-'''-0-0-'''-0-0-'./o--000'


"

#	Not quite sure what to put here but some ideas would be:
#		- Hostname
#		- IP Address
#		- Current Time

# -------------------------- Window Preferences   ----------------------------------------------------------

# -------------------------- Alias Configurations ----------------------------------------------------------
rm alias:\type

$settings = 	"$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

sal vi 		vim
sal type 	gcm
sal unzip 	expand-archive
sal lsblk 	get-disk
sal lspart 	get-partition
sal lsvol 	get-volume

sal chrme 	'C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe' 
sal edg 	'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
sal word 	'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE'

sal spotify "$env:appdata\Spotify\spotify.exe"
sal zoom 	"$env:appdata\Zoom\bin\Zoom.exe"
sal python	"$env:localappdata\Programs\Python\Python38\python.exe"
sal pip		"$env:localappdata\Programs\Python\Python38\Scripts\pip.exe"
sal subl    "$env:localappdata\Programs\Sublime Text Build 3211 x64\subl.exe"

# -------------------------- Function Definitions ----------------------------------------------------------
function uchrome($val){
	chrme --profile-directory="Default" $val
}
function chrome($val){
	chrme --profile-directory="Profile 1" $val
}

function uedge($val){
	edg --profile-directory="Profile 1" $val
}
function edge($val){
	edg --profile-directory="Default" $val
}

function hist(){
	vi (Get-PSReadLineOption).HistorySavePath
}
function mklink ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}
function sudo() {
    start powershell -Verb runas -ArgumentList ('-NoExit', '-Command', 'cd {0}' -f "$(pwd)")
}
function bing() {
	$search = $args[0]
	for ($i=1; $i -lt $args.length; $i++) { $search += "+"+$args[$i] }
	$search = "bing.com/search?q=$search"
	echo $search
	edge $search
}
function grep(){
	[CmdletBinding()]
	Param(
		[Parameter(Position=0)] $filter, 
		[Parameter(ValueFromPipeline)] $obj
	)

	$obj -match $filter | Foreach {$matches[0]}
}
