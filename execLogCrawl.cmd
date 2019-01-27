@echo off
echo Search for string matches, return output.
PowerShell.exe -ExecutionPolicy Bypass -File logCrawl.ps1
PowerShell.exe -ExecutionPolicy Bypass -File trigger_dfsrUsage.ps1