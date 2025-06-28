# Checks preconfigured directory for any RPP backup files. If files exist the
# script calls robocopy to move all files in the directory to a long term
# archival directory to free up space on production disk/volume

# Config
$SourceDir = "F:\Reaper Project Backup Staging"
$DestDir = "B:\Reaper Backup Archives"
$LogFile = "$env:USERPROFILE\reabak.log"
$RppBakMinAge = 3   # How old in days a file is before archive
$PruneBackups = $false
$PruneAgeDays = 365

function Log($msg) {
    "$(Get-Date -Format 's') – $msg" >> $LogFile
}
# Validate the path to the backup files exists
if (!(Test-Path -Path $SourceDir)) {
    Log "WARN $SourceDir does not exist, nothing to do. Exit code 0" 
    exit 0
}

# Validate if Reaper project backup files exist
$files = Get-ChildItem $SourceDir -Filter '*.rpp-bak' -File
if (!$files) {
    Log "WARN no rpp-bak files found. Exit code 0"
    exit 0
}

# Invoke robocopy
Log "INFO starting robocopy"
robocopy "$SourceDir" "$DestDir" /MOV /MINAGE:$RppBakMinAge /XX /NP /log:"$LogFile"

# Remove rpp-bak files on the destination older than 365 days
# Optional function, does not delete anything by default
if ($PruneBackups) {
    Log "INFO Backup Pruning enabled"
    $FilesToPrune = Get-ChildItem $DestDir -Filter '*.rpp-bak' -File |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$PruneAgeDays) }
    if (!$FilesToPrune) {
        Log "INFO No .rpp-bak files older than $PruneAgeDays days"
    }
    else {
        Log "INFO $($FilesToPrune.Count) backups older than $PruneAgeDays days marked for removal"
        $FilesToPrune | ForEach-Object {
            Log "INFO Would Delete: $($_.FullName)"
        }
        Log "INFO Starting file removal"
        $FilesToPrune | ForEach-Object {
            $PrunePath = $_.FullName
            try {
                Remove-Item $PrunePath -ErrorAction Stop -WhatIf
                Log "INFO Deleted: $PrunePath"
            }
            catch {
                Log "FAIL Unable to delete $PrunePath - $($_.Exception.Message)"
            } 
        }
    }

}

# Catch errors from robocopy
if ($LASTEXITCODE -gt 3) {
    Log "FATAL robocopy error detected $LASTEXITCODE"
    exit 1
}

exit 0