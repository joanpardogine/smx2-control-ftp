# Defineix la ruta on es desarà la informació recollida
$basePath = "C:\ServeisAlumnes"
$infoFilePath = "$basePath\infoDhcp.txt"

# Recollir el nom del servidor
$nomServidor = (Get-WmiObject -Class Win32_ComputerSystem).Name

# Recollir les MAC addresses i les adreces IP de cada interfície de xarxa
$networkInterfaces = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

# Recollir informació de les interfícies de xarxa
$interficieInfo = ""
foreach ($nic in $networkInterfaces) {
    $mac = $nic.MACAddress
    $ip = $nic.IPAddress[0]
    $interficieInfo += "MAC: $mac, IP: $ip`n"
}

# Recollir la configuració DHCP
$dhcpScopes = Get-DhcpServerv4Scope
$dhcpInfo = ""

if ($dhcpScopes.Count -eq 0) {
    # Si no hi ha àmbits DHCP configurats, afegir el missatge
    $dhcpInfo = "DHCP no configurat"
} else {
    # Si hi ha àmbits configurats, recollir la informació
    foreach ($scope in $dhcpScopes) {
        $nomAmbit = $scope.Name
        $rangInici = $scope.StartRange
        $rangFinal = $scope.EndRange

        # Recollir les reserves associades a l'àmbit
        $reserves = Get-DhcpServerv4Reservation -ScopeId $scope.ScopeId
        $reservesInfo = ""
        foreach ($reservation in $reserves) {
            $reservesInfo += "Reserva - MAC: $($reservation.ClientId), IP: $($reservation.IPAddress)`n"
        }

        $dhcpInfo += "Àmbit: $nomAmbit, Rang: $rangInici - $rangFinal`nReserves:`n$reservesInfo`n"
    }
}

# Escriure tota la informació recollida al fitxer
$informacioCompleta = @"
Nom del servidor: $nomServidor

Interfícies de xarxa:
$interficieInfo

Configuració DHCP:
$dhcpInfo
"@

# Desa la informació al fitxer
$informacioCompleta | Out-File -FilePath $infoFilePath -Encoding UTF8

Write-Host "S'ha recollit la informació DHCP i s'ha desat a $infoFilePath"
