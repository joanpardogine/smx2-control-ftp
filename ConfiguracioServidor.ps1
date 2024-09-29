# Definir variables
$baseDir = "$env:USERPROFILE\Documents\Control_Servidor"
$username = "NomUsuari"  # Canvia "NomUsuari" pel nom que vulguis
$password = ConvertTo-SecureString "LaTevaContrasenyaSegura" -AsPlainText -Force  # Canvia per la contrasenya que vulguis

# Comprovar si el directori base ja existeix
if (-Not (Test-Path $baseDir)) {
    # Crear les carpetes necessàries
    New-Item -ItemType Directory -Path "$baseDir\Logs" -Force
    New-Item -ItemType Directory -Path "$baseDir\Scripts" -Force
    New-Item -ItemType Directory -Path "$baseDir\Dades" -Force

    # Copiar fitxers i scripts necessaris
    Copy-Item "$PSScriptRoot\Fitxer1.txt" "$baseDir\Dades\" -Force
    Copy-Item "$PSScriptRoot\Script1.cmd" "$baseDir\Scripts\" -Force
    Copy-Item "$PSScriptRoot\Script2.cmd" "$baseDir\Scripts\" -Force

    Write-Host "Estructura de carpetes creada i fitxers copiats."
} else {
    Write-Host "L'estructura de carpetes ja existeix. No es crea res."
}

# Comprovar si l'usuari ja existeix
if (-Not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
    # Crear l'usuari
    New-LocalUser -Name $username -Password $password -FullName "Usuari de Control" -Description "Usuari creat per control del servidor" -PasswordNeverExpires $true
    Write-Host "L'usuari $username ha estat creat amb èxit."
} else {
    Write-Host "L'usuari $username ja existeix. No es crea res."
}
