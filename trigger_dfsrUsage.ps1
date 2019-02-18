# search DFSR log filtered output.
# This script calls the output log for large backlog queues.
# parsed strings output log will be parsed to avoid locking with master hourly log file / processes.

$logDirHome = "C:\Log-Dfsr\"
$pathToFile = "C:\Log-Dfsr\Dfsr-LogResults.log"
# full file path, including file name.
$alarmThreshold = 200
# For email alerting, queue size greater than this value will send an email.

$buildRecentQueue = Get-Content $pathToFile -Tail 4
# These are the raw file strings with last x lines by tail command.
# Adding +2 lines as end of last written file has 2 blank lines to get last 2 runs from dfsr check.
# before any string modifications applied.  Echoed below via Write-Output for debugging.
#$buildRecentQueue | Write-Output

# Log Trim cleanup 01:
# brackets need escaped.  Removal of ': ' added into sub string below this trim transform
$justNumValues = $buildRecentQueue.Trimstart('[Member \<SITE-FS02\> Backlog File Count] | [Member \<SITE-FS01\> Backlog File Count]')
# Additional test strings echoed below.  Confirming most characters before numeric values trimmed.
#$justNumValues
#Write-Output "The above are test values echoed for confirmation by justNumValues line"
#Write-Output `n

# Log Trim cleanup 02:
$realNumStrings = $justNumValues.Trim(': ')
#$realNumStrings
#Write-Output "These above are the raw parsed values of Queue."

# Output these results to a flat file for re-import processing.
### Irrelevant since I invoke the Strings directly. However outputting for execution debug
$realNumStrings | Out-File "$($logDirHome)lastState_dfsrQueue.log"

#Write-Warning "Raw values in String format"
# Import file and process logic.
### comment out and try to exec without import as string.
#$validateQueue = Get-Content "C:\Log-Dfsr\lastState_dfsrQueue.log" | Out-String
$validateQueue = $realNumStrings
$rawQueueInt = $validateQueue | ForEach-Object {$PSItem -as [int]}
# Cast array as int, else the -gt check will fail and be inconsistent.
# Debug echo below:
Write-Host $validateQueue

# Logic Check for email. Proper comparison operator needs to be used.  Not > but -gt
# value after -gt is threshold queue size to email.  -ge is Greater Than or Equal. Currently this is the sum of last 2 runs for DFSR.
If ($rawQueueInt -gt $alarmThreshold) {
    Write-Warning "Large Queue trigger invoking";
    Write-Output "Doing SMTP mail";
    Send-MailMessage -from "noreply@domain.com" -to "notify@domain.com", "notify2@self.com" -subject "DFS Queue Warning: No user action required" -body "Backlog Queue Threshold of $alarmThreshold exceeded." -SmtpServer 192.168.0.10;
    }
    Else {Write-Host "Queue size for recent checks below threshold. No notifcation triggered."
    }

# Current iteration only seems to be checking 3 digits. with a queue these are not being treated as Int in the above Validate Queue.
# Backup of non-Int checking below:
#If ($validateQueue -gt 100000) {
    #Write-Warning "Large Queue trigger invoking";
    #Write-Output "Doing SMTP mail";
    #}
    #Else {Write-Host "Queue size for recent checks below threshold. No notifcation triggered."
    #}
