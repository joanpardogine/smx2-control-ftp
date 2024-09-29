# smx2-control-ftp

Passos per afegir al vostre servidor amb windows les eines per dur a terme els controls de les activitats.



**1.** 


PS C:\Users\Administrator> C:\ServeisAlumnes\creaCarpetes.ps1
S'ha trobat informació de l'alumne: Pedrosa Morales, Siscu.
L'estructura de carpetes per a l'alumne 'Pedrosa Morales, Siscu' ja existeix.
Move-Item : Cannot find path 'C:\Users\administrator\Desktop\creaCarpetes.ps1' because it does not exist.
At C:\ServeisAlumnes\creaCarpetes.ps1:84 char:1
+ Move-Item -Path $scriptActual -Destination $basePath -Force
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Users\admini...reaCarpetes.ps1:String) [Move-Item], ItemN
   otFoundException
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.MoveItemCommand

Els fitxers han estat moguts a la carpeta 'C:\ServeisAlumnes'.
