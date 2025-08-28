# ===========================================================================================================
# Script de PowerShell para instalar OpenSSH Server en Windows
# ===========================================================================================================

# Requiere privilegios de administrador para la instalación
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Este script debe ser ejecutado como administrador. Por favor, reinicia PowerShell con privilegios elevados." -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit
}

Write-Host "Iniciando la instalación de OpenSSH Server en Windows..." -ForegroundColor Cyan

# --- 1. Detección del paquete de OpenSSH Server ---
$sshServerPackageName = "OpenSSH.Server~~~~0.0.1.0"
$sshServerPackage = Get-WindowsCapability -Online | Where-Object { $_.Name -eq $sshServerPackageName }

if ($sshServerPackage -eq $null) {
    Write-Host "No se encontró el paquete de OpenSSH Server. Verifique el nombre del paquete en su versión de Windows." -ForegroundColor Red
    exit 1
}

Write-Host "Paquete detectado: $($sshServerPackage.Name)" -ForegroundColor Green

# --- 2. Instalación del paquete (si no está instalado) ---
if ($sshServerPackage.State -ne 'Installed') {
    Write-Host "El paquete no está instalado. Iniciando la instalación..." -ForegroundColor Yellow
    Add-WindowsCapability -Online -Name $sshServerPackageName -ErrorAction Stop
    Write-Host "OpenSSH Server se ha instalado correctamente." -ForegroundColor Green
} else {
    Write-Host "OpenSSH Server ya está instalado. Omitiendo el paso de instalación." -ForegroundColor Yellow
}

# --- 3. Configuración y reinicio del servicio sshd ---
Write-Host "Configurando el servicio SSH..." -ForegroundColor Cyan

# Asegura que el servicio se inicie automáticamente
Set-Service -Name 'sshd' -StartupType 'Automatic' -ErrorAction SilentlyContinue

# Intenta iniciar el servicio
try {
    Start-Service -Name 'sshd' -ErrorAction Stop
    Write-Host "Servicio 'sshd' iniciado y configurado para arrancar automáticamente." -ForegroundColor Green
} catch {
    Write-Host "Error al iniciar el servicio 'sshd'. Por favor, verifica los logs de eventos de Windows para más detalles." -ForegroundColor Red
    Write-Host "Intenta reiniciar el sistema o verificar las dependencias." -ForegroundColor Yellow
    exit 1
}

# --- 4. Configuración del Firewall de Windows ---
Write-Host "Creando una regla en el Firewall de Windows para permitir conexiones SSH..." -ForegroundColor Cyan
$ruleName = "OpenSSH-Server-Inbound-Rule"

# Elimina la regla existente si la hay para evitar duplicados
Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false

# Crea la nueva regla para el puerto TCP 22
New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow -Profile Any -Description "Permite conexiones SSH (puerto 22) para el servicio OpenSSH Server."

Write-Host "Regla del Firewall creada/actualizada para permitir el tráfico SSH en el puerto 22." -ForegroundColor Green

Write-Host "==========================================================================================================="
Write-Host "¡Instalación y configuración de OpenSSH Server completada!" -ForegroundColor Green
Write-Host "Ahora puedes conectarte a este equipo usando un cliente SSH, por ejemplo:" -ForegroundColor White
Write-Host "ssh tu_usuario@IP_del_equipo" -ForegroundColor Yellow
Write-Host "==========================================================================================================="

winget upgrade --all --accept-source-agreements --accept-package-agreements
