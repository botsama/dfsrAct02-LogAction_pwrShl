# dfsrAct02-LogAction_pwrShl
This script processes master log file, scrapes relevant lines, then runs validation loop for email to send, if threshold met.

**For Server 2012 non-R2 lacking PowerShell DFSR utilities**

logCrawl.ps1:
Checks master log file from [Act01 script](https://github.com/botsama/dfsrAct01-LogMake_pwrShl) for a string relevant to files in queue for replication.
Grabs entire line matching search string and outputs results to new file.  Only containing files in queue count.

trigger_dfsrUsage.ps1
Additional stripping of the filtered file. End result is just the number of files in queue pending replication.
