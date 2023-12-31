# Solicita al usuario el nombre de la tarea
$TaskName = Read-Host "Ingrese el nombre de la tarea"

# Solicita al usuario la acción (PowerShell o ejecutable)
$ActionType = Read-Host "Ingrese el tipo de acción (PowerShell/ejecutable)"
if ($ActionType -eq "PowerShell") {
    $ScriptPath = Read-Host "Ingrese la ruta del script de PowerShell (por ejemplo, 'C:\Users\Public\repair.ps1'):"
    $Action = New-ScheduledTaskAction -Execute "PowerShell" -Argument $ScriptPath
} elseif ($ActionType -eq "ejecutable") {
    $ExecutablePath = Read-Host "Ingrese la ruta del ejecutable (por ejemplo, 'C:\ruta\a\tu\ejecutable.exe'):"
    $Action = New-ScheduledTaskAction -Execute $ExecutablePath
} else {
    Write-Host "Tipo de acción no válido. Debe ser 'PowerShell' o 'ejecutable'."
    exit
}

# Configura el disparador para que se ejecute al inicio
$TriggerStartup = New-ScheduledTaskTrigger -AtStartup

# Configura las opciones de la tarea
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$Settings.Compatibility = "Win8"

# Configura el principal para ejecución con privilegios elevados
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount

# Registra la tarea programada
Register-ScheduledTask -Action $Action -Trigger $TriggerStartup -Settings $Settings -Principal $Principal -TaskName $TaskName

# Obtén la tarea programada existente
$Task = Get-ScheduledTask -TaskName $TaskName

# Configura las opciones de detención de la tarea
$Task.Settings.ExecutionTimeLimit = "PT0S"  # Desactiva el límite de tiempo de ejecución
$Task.Settings.AllowHardTerminate = $true   # Permite la terminación forzada

# Configura la ejecución con privilegios elevados
$Task.Principal.RunLevel = "Highest"

# Configura la tarea para ejecutarse en modo oculto
$Task.Settings.Hidden = $true

# Configura la opción de reinicio en caso de fallo
$Task.Settings.RestartCount = 10
$Task.Settings.RestartInterval = "PT0H1M0S"  # Intervalo de 1 minuto

# Desactiva la opción de detener la tarea en ejecución si no finaliza cuando se solicita
$Task.Settings.AllowHardTerminate = $false

# Actualiza la tarea programada con las nuevas configuraciones
Set-ScheduledTask -TaskName $TaskName -Principal $Task.Principal -Settings $Task.Settings

Write-Host "Tarea programada configurada como $TaskName para ejecutar la acción: $ActionType, en modo oculto, con reinicio en caso de fallo y sin detener el script en ejecución si no finaliza cuando se solicita."

Start-ScheduledTask -TaskName $TaskName