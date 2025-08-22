# PowerShell One-Liners

## Filesystem

### Restore the filesystem health

```PowerShell
DISM /Online /Cleanup-Image /StartComponentCleanup
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
SFC /scannow
```

## System Administration

### Reboot or shutdown the computer

```PowerShell
shutdown /r /s /f /t 0
```

> [!TIP]
> The `r` switch reboots the computer after shutdown. Omitting this flag will cause the computer to stay powered off.

### Windows Defender: Update antivirus definitions

```PowerShell
Update-MpSignature -UpdateSource MicrosoftUpdateServer
```

> [!TIP]
> `-UpdateSource MicrosoftUpdateServer` requires Windows Update to be enabled on the system. If it's restricted or disabled for policy compliance, use the `-UpdateSource MMPC` option.

### Windows Defender: Antivirus scan

```PowerShell
Start-MpScan -ScanType FullScan
```

> [!TIP]
> `-ScanType FullScan` performs a scan on the entire filesystem. To perform a quick scan, use the `-ScanType QuickScan` option.

### Windows Defender: Antimalware software status

```PowerShell
Get-MpComputerStatus
```

## System Events

### Return the last AppLocker event where an application was prevented from running

```PowerShell
Get-AppLockerFileInformation -EventLog -EventType Denied | fl
```
