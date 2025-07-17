# Software Center (SCCM) Client Reinstallation

## 1. Description

Reinstallation of Software Center (SCCM) on a client computer is only recommended in extreme scenarios:

- You've been instructed by higher support personnel.
- Software Center cannot be opened anymore. For example, you receive this error when trying to launch Software Center<b>*</b>:

![Software Center error](./Assets/software-center-some-components-can-not-be-loaded.png)

<b>*</b> For this particular error message, it's best to first verify if Provisioning Mode is enabled:

1. Navigate to `HKLM\SOFTWARE\Microsoft\CCM\CcmExec` in Registry Editor.

2. Check the value of `ProvisioningMode`: it will be either `true` (enabled) or `false` (disabled).

3. To disable Provisioning Mode, run this in an elevated PowerShell prompt: `Powershell.exe Invoke-WmiMethod -Namespace "root\CCM" -Class "SMS_Client" -Name "SetClientProvisioningMode" $false`

4. Reboot the computer.

## 2. Information

Special care and attention must be taken when reinstalling Software Center. It is a lengthy process and may cause system damage if not done correctly.

Pay attention to the installation steps, because some switches may be required; for example, `/mp:<hostname>.<domain> SMSSITECODE=<siteCode>` and/or `/usePKICert`.

> [!CAUTION]
> **Consult the documentation of your organization or environment on the specific steps and requirements when reinstalling Software Center.**

## 3. Solution

### 3.1. Prerequisites

**Copy the SCCM client installation files** from your software distribution repository to the user's computer (for example, `C:\Temp\SCCM_Client`).

### 3.2. Uninstallation

1. **Uninstall the software using the commandline:**

    1. Run PowerShell as Administrator.
    2. Navigate to Software Center's installation directory: `cd C:\Windows\ccmsetup`
    3. Run the setup file with the uninstallation switch: `.\ccmsetup.exe /uninstall`
    4. Wait for the uninstallation to finish.

    💡 It's best to run Task Manager as Administrator and monitor the background tasks. I recommend closing all Software Center related processes: `CcmExec.exe`, `SCNotification.exe` etc. If CPU usage stays dormant for longer than 10 minutes with no activity, I recommend closing all `WMI Provider Host` tasks (`WmiPrvSE.exe` process). They will restart (this is normal), but should cause the uninstallation process to proceed.

2. **Remove residual Software Center data files** by deleting:

    - `C:\Windows\ccmsetup`
    - `C:\Windows\ccmcache`
    - `C:\Windows\CCM`

    💡 The `CCM` folder often cannot be deleted as a whole. If that is the case, this is caused by the `ScriptStore` folder inside: delete everything inside `CCM` with the exception of `ScriptStore`.

3. **Reboot** the computer.

### 3.3. Installation

1. **Start the installation using the commandline:**

    1. Run PowerShell as Administrator.
    2. Navigate to the folder of the copied SCCM client installation files: `cd C:\Temp\SCCM_Client`.
    3. Run the installer: `.\ccmsetup.exe`

2. **Monitor the installation log file and wait for the return code:** `C:\Windows\ccmsetup\Logs\ccmsetup.log`. The installation is silent, there is no installation wizard.

3. You should see `CcmSetup is exiting with return code 0` upon successful installation.

💡 Other possible return codes and their causes: https://www.systemcenterdudes.com/sccm-client-installation-error-codes/

### 3.4. Post-Installation

1. **Wait for 1 hour** before trying to open Software Center. Software Center uses this time to update its internal components and pull in new software.

2. Run **all options** from *Control Panel* -> *Configuration Manager* -> *Actions*.

3. **Update the group policies** in PowerShell: `gpupdate /force`

4. **Test Software Center** to make sure it opens and runs correctly.
