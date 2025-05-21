Simple UI for looking up users in AD. This gives name, position, location, email, phone number, lockout status, 
and manager all in one spot. 

![image](https://github.com/user-attachments/assets/63d5aaf6-3738-4fc3-bada-563f5ff73d60)

The unlock button will also work as long as you uncomment the line of code at the beginning that says:
``if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }``

This will check for if the current powershell script is running as admin and elevates it if not.

The background and icon image can also be changed by changing the paths for $backPath and $iconPath respectively.
