function WOL($mac, $ip, $port) {

    $MacByteArray = $mac -split "[:-]" | ForEach-Object {
        [Byte] "0x$_";
    };
    [Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray * 16);

    $UdpClient = New-Object System.Net.Sockets.UdpClient;
    $UdpClient.Connect(([System.Net.IpAddress]::Parse($ip)), $port);
    $UdpClient.Send($MagicPacket, $MagicPacket.Length);

    $UdpClient.Close();
}

function WakeUp-Desktop() {
    WOL '70:85:c2:fb:52:8f' '192.168.11.114' 9;
}

function Sleep-Desktop() {
    ssh Singh@192.168.11.114 -i ~\.ssh\id_rsa 'powershell Sleep-Computer; exit';
}

function Shutdown-Desktop() {
    ssh Singh@192.168.11.114 -i ~\.ssh\id_rsa 'powershell shutdown -s -t 0; exit';
}
