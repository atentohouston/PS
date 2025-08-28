# Detener y deshabilitar servicios seleccionados Para ganar uns FPS más...
# Ejecutar PowerShell como Administrador

$services = @(
    "LanmanServer", # Servidor (Server)
    "Spooler",      # Cola de impresión (Print Spooler)
    "DiagTrack",    # Experiencias de usuario y telemetría (Connected User Experiences and Telemetry)
    "Fax",          # Fax
    "TapiSrv",      # Telefonía (Telephony)
    "WbioSrvc"      # Servicio biométrico de Windows (Windows Biometric Service)
)

foreach ($svc in $services) {
    if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
        Write-Host "Deteniendo y deshabilitando servicio: $svc"
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled
    } else {
        Write-Host "El servicio $svc no existe en este sistema."
    }
}

Write-Host "✔ Todos los servicios especificados fueron detenidos y deshabilitados."

winget upgrade --all --accept-source-agreements --accept-package-agreements
winget upgrade --all --accept-source-agreements --accept-package-agreements --include-unknown
winget update --all
winget update --all --include-unknown

powercfg -setactive SCHEME_MAX

# Ejecutar PowerShell como Administrador
Write-Host "🚀 Iniciando actualización completa de drivers y Windows..." -ForegroundColor Cyan

# 1️⃣ Actualización de drivers vía Windows Update / pnputil
Write-Host "`n🔹 Actualizando drivers de dispositivos conectados vía Windows Update..."

$devices = pnputil /enum-devices /connected | Select-String "Instance ID"

foreach ($line in $devices) {
    $instanceId = ($line -split ":")[1].Trim()
    Write-Host "Actualizando driver del dispositivo: $instanceId"
    try {
        pnputil /update-driver $instanceId /install
    } catch {
        Write-Host "⚠ No se pudo actualizar: $instanceId"
    }
}

# 2️⃣ Detectar GPU y usar actualizador oficial
Write-Host "`n🔹 Detectando GPU y actualizando drivers oficiales..."

# Detectar GPU
$gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1 -Property Name
Write-Host "GPU detectada: $($gpu.Name)"

if ($gpu.Name -match "NVIDIA") {
    Write-Host "Ejecutando actualización de NVIDIA GeForce Experience..."
    Start-Process "https://www.nvidia.com/Download/Scan.aspx?lang=en-us"
} elseif ($gpu.Name -match "AMD") {
    Write-Host "Ejecutando actualización de AMD Adrenalin Software..."
    Start-Process "https://www.amd.com/en/support"
} elseif ($gpu.Name -match "Intel") {
    Write-Host "Ejecutando Intel Driver & Support Assistant..."
    Start-Process "https://www.intel.com/content/www/us/en/support/detect.html"
} else {
    Write-Host "No se detectó GPU compatible con actualizador automático."
}

# 3️⃣ Ejecutar Windows Update para actualizaciones de sistema y drivers
# Hacer que se autoconfirme
Write-Host "`n🔹 Ejecutando Windows Update..."
Install-Module PSWindowsUpdate -Force -Scope CurrentUser
Import-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install -AutoReboot

Write-Host "`n✅ Actualización completa finalizada."

# Ejecutar PowerShell como Administrador
Write-Host "🧹 Iniciando limpieza de archivos temporales y caché..." -ForegroundColor Cyan

# 1️⃣ Limpiar carpeta de archivos temporales del usuario
$tempUser = "$env:LOCALAPPDATA\Temp"
if (Test-Path $tempUser) {
    Write-Host "Limpiando archivos temporales del usuario: $tempUser"
    Remove-Item "$tempUser\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# 2️⃣ Limpiar carpeta Temp de Windows
$tempWin = "C:\Windows\Temp"
if (Test-Path $tempWin) {
    Write-Host "Limpiando archivos temporales de Windows: $tempWin"
    Remove-Item "$tempWin\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# 3️⃣ Limpiar caché de Internet Explorer / Edge (si aplica)
Write-Host "Limpiando caché de Internet Explorer / Edge..."
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255

# 4️⃣ Limpiar Prefetch
$prefetch = "C:\Windows\Prefetch"
if (Test-Path $prefetch) {
    Write-Host "Limpiando Prefetch..."
    Remove-Item "$prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# 5️⃣ Limpiar Papelera de reciclaje
Write-Host "Vaciando Papelera de reciclaje..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Host "✅ Limpieza completada."



# Ejecutar PowerShell como Administrador

Write-Host "🧹 Eliminando todas las exclusiones de Windows Defender..." -ForegroundColor Cyan

# Quitar exclusiones de archivos y carpetas
Get-MpPreference | Select-Object -ExpandProperty ExclusionPath | ForEach-Object {
    Remove-MpPreference -ExclusionPath $_
}

# Quitar exclusiones de extensiones
Get-MpPreference | Select-Object -ExpandProperty ExclusionExtension | ForEach-Object {
    Remove-MpPreference -ExclusionExtension $_
}

# Quitar exclusiones de procesos
Get-MpPreference | Select-Object -ExpandProperty ExclusionProcess | ForEach-Object {
    Remove-MpPreference -ExclusionProcess $_
}

Write-Host "✅ Todas las exclusiones han sido eliminadas."

Install-Module PSWindowsUpdate -Force -Scope CurrentUser
Import-Module PSWindowsUpdate


# Buscar y aceptar todas las actualizaciones, instalar y reiniciar automáticamente si es necesario
Get-WindowsUpdate -AcceptAll -Install -AutoReboot

Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force
Clear-History
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force
