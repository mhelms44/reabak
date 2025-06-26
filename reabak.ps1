# Checks preconfigured directory for any RPP backup files. If files exist the
# script calls robocopy to move all files in the directory to a long term
# archival directory to free up space on production disk/volume
# Some basic sanity checks are done to make sure files are present 
# Very crude logging for both the files + robocopy output.
<#
    TODO
    Change all the hard coded paths, etc. to variables
    Need to make robocopy only target the right file type
    Would be nice to have better logging in place
    Also need logic to auto rotate file list log after X size/number of days
    Robocopy should overwrite the log but the other conditions will not
    For now everything seems to work okay
#>

# Config
$SourceDir = "F:\Reaper Project Backup Staging"
$DestDir = "B:\Reaper Backup Archives"
$LogFile = "$env:USERPROFILE\reabak.log"

# Validate the path to the backup files exists and has files. If false
# the script will stop here. 
if (!(Test-Path -Path $SourceDir)) {
    Get-Date >> "C:\Users\Michael\reabak.log"
    "$SourceDir does not exist, nothing to do. Exit code 0" >> "C:\Users\Michael\reabak.log"
    exit 0
}

# All the good stuff happens here. If files are detected in the path robocopy 
# Will move all files in the directory. 
elseif (Test-Path -Path 'F:\Reaper Project Backup Staging\*') {
    # Commenting out this part for debug use. In future would be nice to set with a flag 
    #Get-Date >> "C:\Users\Michael\reabakERROR.log"
    #"Starting Reaper project backup transfer. Here is a list of files up for transfer:" >> "C:\Users\Michael\reabakERROR.log"
    #Get-ChildItem -Path "F:\Reaper Project Backup Staging\" -Filter *.rpp-bak -r | Format-List -Property ('Name') >> "C:\Users\Michael\reabakERROR.log"
    robocopy 'F:\Reaper Project Backup Staging\ ' 'B:\Reaper Backup Archives\ ' /MOV /XX /NP /log:"C:\Users\Michael\reabak.log"
}

# Generic catch all. I can't imagine this would ever actually evaluate as true.
else {
    "Something went wrong, sorry." >> "C:\Users\Michael\reabak.log"
}