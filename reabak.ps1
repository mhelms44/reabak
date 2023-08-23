# Checks preconfigured directory for any RPP backup files. If files exist the
# script calls robocopy to move all files in the directory to a long term
# archival directory to free up space on production disk/volume
# Some basic sanity checks are done to make sure files are present 
# Very crude logging for both the files + robocopy output. Currently the file
# list logs are not rotated, robocopy logs overwrite each time
<#
    TODO
    Change all the hard coded paths, etc. to variables
    Need to make robocopy only target the right file type
    Add some testing scenarios to handle possible weird corner cases
    Would be nice to have better logging in place, specifically formatting
    Also need logic to auto rotate file list log after X size/number of days
    For now everything seems to work okay
#>

# Validate the path to the backup files exists and has files. If false
# the script will stop here. 
if (!(Test-Path -Path 'F:\Reaper Project Backup Staging\*'))
{
    Get-Date >> "C:\Users\Michael\test.txt"
    "There is nothing to backup, exiting now" >> "C:\Users\Michael\test.txt"
}

# All the good stuff happens here. If files are detected in the path robocopy 
# Will move all files in the directory. 
elseif (Test-Path -Path 'F:\Reaper Project Backup Staging\*')
{
Get-Date >> "C:\Users\Michael\test.txt"
"Starting Reaper project backup transfer. Here is a list of files up for transfer:" >> "C:\Users\Michael\test.txt"
Get-ChildItem -Path "F:\Reaper Project Backup Staging\" -Filter *.rpp-bak -r | Format-List -Property ('Name') >> "C:\Users\Michael\test.txt"
robocopy 'F:\Reaper Project Backup Staging\ ' 'B:\Reaper Backup Archives\ ' /MOV /log:"C:\Users\Michael\robotest.txt"
}

# Generic catch all. I can't imagine this would ever actually evaluate as true.
else {
    "Something went wrong, sorry." >> "C:\Users\Michael\test.txt"
}
