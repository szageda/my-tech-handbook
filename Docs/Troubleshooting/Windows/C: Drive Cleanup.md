# C: Drive Cleanup

## 1. Description

The computer's C: drive has already or nearly filled up requiring a cleanup.

![Full C: drive](./Assets/windows-c-drive-full.png)

## 2. Solution

1. **Clean up temporary data folders** (delete everything inside):

    - `C:\Users\%username%\AppData\Local\Temp`
    - `C:\Windows\Temp`
    - `C:\Users\%username%\Downloads`

> [!TIP]
> Delete all items in the folders using <kbd>Shift</kbd>+<kbd>Del</kbd>: this way the data will be deleted permanently instead of moving it into the Recycle Bin.

> [!TIP]
> If your organization is using Software Center (SCCM) for software distribution, delete the `C:\Windows\ccmcache` folder.

2. **Remove Outlook data files (.ost)** in `C:\Users\%username%\AppData\Local\Microsoft\Outlook`

> [!CAUTION]
> Do **<ins>NOT</ins>** delete any offline archive (.pst) files! They cannot be recovered once deleted.

3. **Uninstall unnecessary software** via *Windows Settings* -> *Installed apps* or *Control Panel* -> *Programs & Features*.

4. **Remove unused and unknown Windows profiles** via *Control Panel* -> *System* -> *Advanced system settings* -> *User Profiles* -> *Settings...*

> [!CAUTION]
> Do **<ins>NOT</ins>** delete the user's profile, your administrator account's profile (if you've elevated privileges), the built-in default profiles (Default Profile, Public Profile).

5. **Run Disk Cleanup**, click **Clean up system files**, select all **Files to delete**, then click **OK**:

![Disk Cleanup screenshot](./Assets/windows-disk-cleanup.png)
