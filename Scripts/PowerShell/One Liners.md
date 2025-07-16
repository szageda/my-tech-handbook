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

## System Events

### Return the last AppLocker event where an application was prevented from running

```PowerShell
Get-AppLockerFileInformation -EventLog -EventType Denied | fl
```
