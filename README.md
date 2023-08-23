# reabak
Starting a project to help automate management of Reaper project backups, which in my opinion are handled in a somewhat unideal way in most cases. The current powershell script is extremely hacky and crude right now, but overtime I plan to make it more robust and portable with more flexibility for different usecases. 

Currently the script is setup to run as a weekly scheduled task and simply checks if a directory I configured in Reaper to automatically save backup project files is empty or not. If it is not empty it calls robocopy to move them all off to a larger capacity mechanical drive for longer term storage. Flash may be cheap but that doesn't mean I want to bloat my SSD space with 10s of 100s of gigs worth of backup project files. I also don't want to ever be stuck waiting for an automatic save to complete waiting for an HDD to spin up, or network latency for a NAS, etc.
