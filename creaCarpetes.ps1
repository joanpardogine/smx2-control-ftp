# Ruta base per a les carpetes
$basePath = "C:\ServeisAlumnes"
$desktopPath = "C:\Users\administrator\Desktop\"

# Ruta per al fitxer que conté els noms d'alumnes

$nomFitxerAlumnes = "alumnes.txt"  
$nomScriptActual = "creaCarpetes.ps1"  
$nomFitxerRegitre = "registre.txt"  
$nomFitxerControl = "control.txt"

$fitxerAlumnes = Join-Path -Path $desktopPath -ChildPath $nomFitxerAlumnes # Ruta a alumnes.txt
$scriptActual = Join-Path -Path $desktopPath -ChildPath $nomScriptActual # Ruta a creaCarpetes.ps1

# Ruta per al fitxer de registre
$registrePath = Join-Path -Path $basePath -ChildPath $nomFitxerRegitre
$controlPath = Join-Path -Path $basePath -ChildPath $nomFitxerControl  # Fitxer per guardar la informació de l'alumne

# Comprovar si el fitxer d'alumnes existeix
if (-Not (Test-Path -Path $fitxerAlumnes)) {
    Write-Host "El fitxer d'alumnes no existeix. Assegura't que el fitxer estigui a la ruta especificada."
    exit
}

# Comprovar si el fitxer de control existeix
$nomAlumne = $null
if (Test-Path -Path $controlPath) {
    $nomAlumne = Get-Content -Path $controlPath
    Write-Host "S'ha trobat informació de l'alumne: $nomAlumne."
} else {
    # Llegir el contingut del fitxer d'alumnes
    $alumnes = Import-Csv -Path $fitxerAlumnes -Delimiter ';'

    # Mostrar la llista d'alumnes i demanar que seleccionin un nom
    Write-Host "Selecciona el teu nom de la llista següent:"

    for ($i = 0; $i -lt $alumnes.Length; $i++) {
        Write-Host "$($i + 1): $($alumnes[$i].'Alumne/a')"
    }

    # Demanar a l'usuari que selecciona un alumne
    $seleccio = Read-Host "Introdueix el número corresponent al teu nom"

    # Validar la selecció
    if ($seleccio -as [int] -and $seleccio -ge 1 -and $seleccio -le $alumnes.Length) {
        $nomAlumne = $alumnes[$seleccio - 1].'Alumne/a'
        $nomCarpeta = $alumnes[$seleccio - 1].carpeta
        # Guardar la informació de l'alumne seleccionat al fitxer de control
        $nomAlumne | Out-File -FilePath $controlPath -Encoding UTF8
    } else {
        Write-Host "Selecció no vàlida. Sortint."
        exit
    }
}

# Ruta per a les carpetes de l'alumne
$alumnePath = Join-Path -Path $basePath -ChildPath $nomCarpeta

# Comprovar si el directori base existeix, sinó, créa'l
if (-Not (Test-Path -Path $basePath)) {
    New-Item -ItemType Directory -Path $basePath
}

# Comprovar si les carpetes de l'alumne ja existeixen
if (-Not (Test-Path -Path $alumnePath)) {
    # Crear la carpeta per a l'alumne
    New-Item -ItemType Directory -Path $alumnePath

    # Crear les subcarpetes necessàries
    New-Item -ItemType Directory -Path (Join-Path -Path $alumnePath -ChildPath "Logs")
    New-Item -ItemType Directory -Path (Join-Path -Path $alumnePath -ChildPath "Scripts")
    New-Item -ItemType Directory -Path (Join-Path -Path $alumnePath -ChildPath "Dades")

    # Afegir registre de l'execució
    $dataHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $registreEntry = "$nomAlumne ha executat l'script a $dataHora`n"
    Add-Content -Path $registrePath -Value $registreEntry

    Write-Host "L'estructura de carpetes per a l'alumne '$nomAlumne' ha estat creada."
} else {
    Write-Host "L'estructura de carpetes per a l'alumne '$nomAlumne' ja existeix."
}

# Moure els fitxers a la carpeta "C:\ServeisAlumnes"
Move-Item -Path $fitxerAlumnes -Destination $basePath -Force
Move-Item -Path $scriptActual -Destination $basePath -Force

Write-Host "Els fitxers han estat moguts a la carpeta 'C:\ServeisAlumnes'."
