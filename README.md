A lightweight PowerShell script to automatically move Reaper .rpp-bak backup files with robocopy from a staging folder on my production drive to a long-term archive on a mechanical disk. I use the automatic backup feature in Reaper to save a copy of the project to a directory outside the project directory. Over a period of time this folder tends to build up. Disk space isn't really an issue, but why keep them there long term if they are just a safety net? 

Clone the repository
Configure paths in reabak.ps1
Modify $SourceDir, $DestDir, and $LogFile at the top of the script based on your enviornment.
Add it as a Windows scheduled task. I have my run once a week at 3 AM. 
Add powershell as the program, and add the arguments -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\Backup-Reaper.ps1"
