Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Capturar la pantalla
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$bitmap = New-Object System.Drawing.Bitmap $screen.Bounds.Width, $screen.Bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Bounds.Location, [System.Drawing.Point]::Empty, $screen.Bounds.Size)

# Ruta de destino para guardar la captura de pantalla en la carpeta de Imágenes del usuario
$picturesPath = [System.Environment]::GetFolderPath("MyPictures")
$outputPath = Join-Path $picturesPath "Screenshot.png"

# Guardar la captura de pantalla en la carpeta de Imágenes del usuario
$bitmap.Save($outputPath)

# Liberar recursos
$graphics.Dispose()
$bitmap.Dispose()

Write-Host "Captura de pantalla guardada en: $outputPath"