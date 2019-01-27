# search specific DFSR log flat file and build output.
# Intent is to return results as if were using Grep on a flat file.

$pathToFile = "C:\DFSR_Status\SITE-FS02_DFSR_Status.log"
# full file path, including file name.
$matchStr01 = "> Backlog File Count"

$doCrawl = Select-String $($matchStr01) -Path $($pathToFile) | Select Line
Write-Output $doCrawl | Out-File .\Dfsr-LogResults.log